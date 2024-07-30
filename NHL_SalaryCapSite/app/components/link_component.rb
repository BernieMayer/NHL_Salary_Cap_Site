# frozen_string_literal: true

class LinkComponent < ViewComponent::Base
  def initialize(href:, css_class: "")
    @href = href
    @css_class = css_class
  end

  private

  attr_reader :href, :css_class
end
