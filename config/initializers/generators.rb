Rails.application.config.generators do |g|
  g.orm :active_record, primary_key_type: :uuid
  g.assets false
  g.helper false
  g.jbuilder false
  g.view_specs false
  g.routing_specs false
  g.test_framework nil
  g.template_engine :slim
end

Rails.application.config.generators.after_generate do |files|
  parsable_files = files.filter { |file| file.end_with?('.rb') }
  system("bundle exec rubocop -A --fail-level=E #{parsable_files.shelljoin}", exception: true) if parsable_files.present?
end
