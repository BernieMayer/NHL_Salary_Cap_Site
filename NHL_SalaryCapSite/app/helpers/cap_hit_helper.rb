module CapHitHelper
  def find_cap_hit(team, player, year)
    # Convert the year (e.g., 2025) into the "2025-26" string format
    formatted_year = "#{year}-#{(year + 1).to_s[-2..]}"

    retention = SalaryRetention.joins(contract: :contract_details)
                                .joins(contract: :player)
                                .joins(:team)
                                .where(teams: { id: team.id })
                                .where(players: { id: player.id })
                                .where(contract_details: { season: formatted_year })
                                .select('salary_retentions.retained_cap_hit, salary_retentions.retention_percentage')
                                .first


    if retention
      return retention.retained_cap_hit
    end

    contract_detail = ContractDetail
                        .joins(:contract)
                        .where(contracts: { player: player }, season: formatted_year)
                        .first

    # Return the cap hit from ContractDetail if available, otherwise return nil
    contract_detail&.cap_hit
  end
end