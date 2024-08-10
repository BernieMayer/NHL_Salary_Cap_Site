class LeagueCapTableComponent < ViewComponent::Base
  attr_reader :teams

  def initialize(teams:)
    @teams = teams
  end

  def total_cap_hit(team)
    team.salary_cap_totals.find_by(year: 2024).total
  end

  def cap_space(team) 
    team.salary_cap_totals.find_by(year: 2024).calculate_cap_space
  end

  def formatted_cap_hit(cap_hit)
    number_to_currency(cap_hit, unit: "$", precision: 2)
  end


  def cap_space_text_color(cap_space)
    if cap_space.positive?
      "text-green-500"
    else
      "text-red-500"
    end
  end
end
