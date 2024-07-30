class LeagueCapTableComponent < ViewComponent::Base
  attr_reader :teams

  def initialize(teams:)
    @teams = teams
  end

  def total_cap_hit(team)
    team.salary_cap_totals.find_by(year: 2024).total
  end

  def formatted_cap_hit(cap_hit)
    number_to_currency(cap_hit, unit: "$", precision: 2)
  end
end
