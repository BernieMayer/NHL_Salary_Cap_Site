namespace :players do
  desc 'Backfill slugs for players'
  task backfill_slugs: :environment do
    Player.find_each do |player|
      next unless player.slug.nil?

      base_slug = player.name.downcase.gsub(/\s+/, '-') # Replace spaces with hyphens
      slug = base_slug
      increment = 1

      while Player.exists?(slug: slug)
        slug = "#{base_slug}-#{increment}"
        increment += 1
      end

      player.update(slug: slug)
      puts "Updated #{player.name} with slug: #{slug}"
    end

    puts 'Slug backfilling complete.'
  end
end
