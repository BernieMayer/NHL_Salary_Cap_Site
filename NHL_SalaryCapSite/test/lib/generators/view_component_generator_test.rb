require "test_helper"
require "generators/view_component/view_component_generator"

class ViewComponentGeneratorTest < Rails::Generators::TestCase
  tests ViewComponentGenerator
  destination Rails.root.join("tmp/generators")
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
