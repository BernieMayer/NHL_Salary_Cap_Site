namespace :cleanup do
  desc 'Remove duplicated contracts while keeping one per player'

  task remove_duplicated_contracts: :environment do
    puts 'Starting duplicate contract cleanup...'

    contract_ids_to_delete = []

    Player.find_each(batch_size: 100) do |player|
      puts "Checking player #{player.id}..."

      contracts = player.contracts.includes(:contract_details)

      contract_details_map = {}

      contracts.each do |contract|
        contract.contract_details.each do |detail|
          key = [detail.season, detail.cap_hit] # Change attributes as needed
          contract_details_map[key] ||= []
          contract_details_map[key] << contract
        end
      end

      # Step 3: Identify duplicates and keep one
      contract_details_map.each do |key, contract_array|
        if contract_array.size > 1
          puts "Found duplicates for player #{player.id} with season #{key[0]} and cap hit #{key[1]}."

          # Keep the first contract and mark the rest for deletion
          contract_array[1..-1].each do |contract_to_delete|
            contract_ids_to_delete << contract_to_delete.id
          end
        end
      end
    end

    # Step 5: Delete contracts with duplicated details outside the loop
    if contract_ids_to_delete.any?
      puts "Deleting #{contract_ids_to_delete.size} contracts..."
      Contract.where(id: contract_ids_to_delete).destroy_all
      puts "Deleted contracts: #{contract_ids_to_delete.join(', ')}"
    else
      puts 'No duplicated contracts found to delete.'
    end

    puts 'Duplicate contract cleanup complete.'
  end
end
