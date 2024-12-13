class ApplicationController < ActionController::Base
  before_action :set_default_meta_tags

  private

  def set_default_meta_tags
    set_meta_tags( 
                  description: "Welcome to Cap Smarter, a website for NHL hockey salary cap data!",
                  keywords: "rails, ruby, hockey, nhl, cap smarter",
                  og: {
                    title: "Cap Smarter",
                    description: "Welcome to Cap Smarter, a website for NHL hockey salary cap data!",
                    type: "website",
                    url: request.url
                  })
  end
end
