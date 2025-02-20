require 'rails_helper'

RSpec.describe DraftPick, type: :model do
  let!(:team1) { Team.create(name:"Calgary Flames", code: "CGY") }
  let!(:team2) { Team.create(name: "Edmonton Oilers", code: "EDM")}

  subject {
    described_class.new(
      year: 2024,
      round: 1,
      original_team: team1,
      current_team: team2,
      isTradedAway: false,
      tradedDate: nil,
      conditions: "No conditions"
    )
  }

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a year" do
      subject.year = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a round" do
      subject.round = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without an original team" do
      subject.original_team = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a current team" do
      subject.current_team = nil
      expect(subject).to_not be_valid
    end

    it "is valid without a tradedDate" do
      subject.tradedDate = nil
      expect(subject).to be_valid
    end

    it "is valid without conditions" do
      subject.conditions = nil
      expect(subject).to be_valid
    end
  end

  describe "Associations" do
    it "belongs to an original team" do
      assoc = described_class.reflect_on_association(:original_team)
      expect(assoc.macro).to eq :belongs_to
    end

    it "belongs to a current team" do
      assoc = described_class.reflect_on_association(:current_team)
      expect(assoc.macro).to eq :belongs_to
    end
  end

  describe "Custom Methods" do
    describe '#swap_original_and_current_team' do

      let(:team1) { Team.create!(name: "Anaheim Ducks", code: "ANA") }
      let(:team2) { Team.create!(name: "Boston Bruins", code: "BOS") }
      let(:draft_pick) { DraftPick.create!(year: 2025, round: 1, original_team: team1, current_team: team2) }
      
      it 'swaps the original and current team' do
        expect(draft_pick.original_team).to eq(team1)
        expect(draft_pick.current_team).to eq(team2)
  
        draft_pick.swap_original_and_current_team
  
        expect(draft_pick.reload.original_team).to eq(team2)
        expect(draft_pick.reload.current_team).to eq(team1)
      end

      it 'persists the changes to the database' do
        draft_pick.swap_original_and_current_team
        draft_pick.reload
  
        expect(draft_pick.original_team).to eq(team2)
        expect(draft_pick.current_team).to eq(team1)
      end
    end
  end
end
