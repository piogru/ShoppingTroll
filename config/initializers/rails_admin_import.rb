RailsAdmin.config do |config|
  # REQUIRED:
  # Include the import action
  #See https://github.com/sferik/rails_admin/wiki/Actions
  config.actions do
    all
    import
  end
  # Optional:
  # Configure global RailsAdminImport options
  # Configure pass filename to records hashes
  config.configure_with(:import) do |c|
    c.logging = false
    c.line_item_limit = 1000
    c.update_if_exists = true
    c.pass_filename = false
    c.rollback_on_error = false
    c.header_converter = lambda do |h|
      h.parameterize.underscore if h.present?
    end
    c.csv_options = {}
  end
  # Optional:
  # Configure model-specific options using standard RailsAdmin DSL
  # See https://github.com/sferik/rails_admin/wiki/Railsadmin-DSL
end
