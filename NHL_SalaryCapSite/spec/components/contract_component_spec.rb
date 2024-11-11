# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContractComponent, type: :component do

  let!(:player) {Player.create(name: "John Smith")}
  let!(:contract) { Contract.create!(player: player, expiry_status: "UFA") }

  let!(:contract_details) do
    [
      ContractDetail.create!(contract: contract, season: "2024-2025", aav: 5000000, base_salary: 3000000, cap_hit: 4500000,
       signing_bonuses: 500000, total_salary:  8000000, minors_salary: 200000, clause: "NMC"),
      ContractDetail.create!(contract: contract, season: "2025-2026", aav: 5500000, base_salary: 3500000, cap_hit: 4700000,
       signing_bonuses: 600000, total_salary:  9500000, minors_salary: 220000, clause: "NTC")
    ]
  end

  before do
    render_inline(ContractComponent.new(contract: contract))
  end

  it 'renders something useful' do
   
    rendered_component = render_inline(ContractComponent.new(contract: contract))

    expect(rendered_component.to_html).to include('Cap Hit')
    expect(rendered_component.to_html).to include('AAV')
    expect(rendered_component.to_html).to include('Base')
    expect(rendered_component.to_html).to include('Signing Bonus')
    expect(rendered_component.to_html).to include('Minors Salary')
  end

  it "renders the contract start, end and expiry" do
    page = Capybara::Node::Simple.new(rendered_content)

    expect(page).to have_selector("p", text: "Contract start: 2024-2025 Contract end: 2025-2026", normalize_ws: true)
    expect(page).to have_selector("h2", text: "Expiry status: UFA")
  end

  it "renders the table headers correctly" do
    page = Capybara::Node::Simple.new(rendered_content)

    expect(page).to have_selector("th", text: "Contract Detail")
    expect(page).to have_selector("th", text: "2024-2025")
    expect(page).to have_selector("th", text: "2025-2026")
  end

  it "renders the AAV row correctly" do
    page = Capybara::Node::Simple.new(rendered_content)

    expect(page).to have_selector("td", text: "AAV")
    expect(page).to have_selector("td", text: "$5,000,000")
    expect(page).to have_selector("td", text: "$5,500,000")
  end

  it "renders the Total Salary row correctly" do
    page = Capybara::Node::Simple.new(rendered_content)

    expect(page).to have_selector("td", text: "Total Salary")
    expect(page).to have_selector("td", text: "$8,000,000")
    expect(page).to have_selector("td", text: "$9,500,000")
  end

  it "renders the Clause row correctly" do
    page = Capybara::Node::Simple.new(rendered_content)

    expect(page).to have_selector("td", text: "Clause")
    expect(page).to have_selector("td", text: "NMC")
    expect(page).to have_selector("td", text: "NTC")
  end

  it "renders the Minors Salary row correctly" do
    page = Capybara::Node::Simple.new(rendered_content)

    expect(page).to have_selector("td", text: "Minors Salary")
    expect(page).to have_selector("td", text: "$200,000")
    expect(page).to have_selector("td", text: "$220,000")
  end
end
