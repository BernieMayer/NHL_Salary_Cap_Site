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
    # If you have any custom methods, you can test them here.
  end
end
