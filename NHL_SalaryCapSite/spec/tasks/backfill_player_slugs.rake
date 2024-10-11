require 'rails_helper'

RSpec.describe 'Rake Task: players:backfill_slugs', type: :task do
  let(:task) { Rake::Task['players:backfill_slugs'] }

  before do
    Rake.application.rake_require('tasks/backfill_slugs')
    Rake::Task.define_task(:environment) # Needed to load the environment
  end

  after do
    task.reenable # Allow the task to be re-run in the same test suite
  end

  describe 'slug backfilling' do
    context 'when player does not have a slug' do
      it 'creates a slug from the player name' do
        player = Player.create!(name: 'John Doe')

        task.invoke

        expect(player.reload.slug).to eq('john-doe')
      end
    end

    context 'when multiple players have the same name' do
      it 'generates unique slugs with increments' do
        player1 = Player.create!(name: 'Jane Smith')
        player2 = Player.create!(name: 'Jane Smith')

        task.invoke

        expect(player1.reload.slug).to eq('jane-smith')
        expect(player2.reload.slug).to eq('jane-smith-1')
      end
    end

    context 'when a player already has a slug' do
      it 'does not update the slug if it already exists' do
        player = Player.create!(name: 'John Doe', slug: 'existing-slug')

        task.invoke

        expect(player.reload.slug).to eq('existing-slug')
      end
    end
  end
end
