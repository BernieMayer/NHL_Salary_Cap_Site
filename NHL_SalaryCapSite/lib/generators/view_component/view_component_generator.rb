class ViewComponentGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  def create_view_component
    template "view_component.rb.tt", File.join("app/components", class_path, "#{file_name}_component.rb")
    template "view_component_spec.rb.tt", File.join("spec/components", class_path, "#{file_name}_component_spec.rb")
  end
end

