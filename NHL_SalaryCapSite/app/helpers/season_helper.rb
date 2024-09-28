module SeasonHelper
  def format_year_to_season(year)
    "#{year}-#{(year + 1).to_s[-2..]}"
  end
end