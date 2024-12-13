namespace :players do
  desc "Fetch player profile images from CapWages"
  task fetch_images: :environment do
    # Iterate over each player in the roster
    Player.roster.find_each do |player|
      # Replace spaces with hyphens in the player's name
      profile_url = "https://capwages.com/players/#{player.name.tr(' ', '-').downcase}"

      # Fetch the profile page and extract the first image tag with class 'rounded-full'
      image_url = fetch_player_image(profile_url)

      # Update the player's image_url if an image is found
      if image_url
        # Decode the URL to get it in the correct format
        decoded_image_url = URI.decode_www_form_component(image_url)

        # Remove everything after the last '&' in the decoded URL
        cleaned_image_url = decoded_image_url.split('&').first

        player.update(image_url: cleaned_image_url)
        puts "Updated #{player.name} image URL: #{cleaned_image_url}"
      else
        puts "No image found for #{player.name}."
      end
    end
  end

  # Function to fetch player image from CapWages
  def fetch_player_image(profile_url)
    begin
      # Open the player's profile page
      html = URI.open(profile_url)
      doc = Nokogiri::HTML(html)

      # Find the first image tag with the class 'rounded-full'
      image_tag = doc.css('img.rounded-full').first

      # Check if the image tag is present and extract the image URL after 'url='
      if image_tag
        src = image_tag['src']
        if src && src.include?('url=')
          # Extract the full URL including query parameters after 'url='
          image_url = src.split('url=').last
          return image_url
        end
      end
      nil
    rescue OpenURI::HTTPError => e
      puts "Error accessing #{profile_url}: #{e.message}"
      nil
    rescue => e
      puts "An error occurred while fetching image for #{profile_url}: #{e.message}"
      nil
    end
  end
end
