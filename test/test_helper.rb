$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "dropkiq"

require "minitest/autorun"


db_config = YAML.load_file(File.expand_path("../database.yml", __FILE__)).fetch(ENV["DB"] || "sqlite")
ActiveRecord::Base.establish_connection(db_config)
ActiveRecord::Schema.verbose = false

def setup_db
  # sqlite cannot drop/rename/alter columns and add constraints after table creation
  sqlite = ENV.fetch("DB", "sqlite") == "sqlite"

  ActiveRecord::Base.connection.create_table :people do |t|
    t.column :name, :string
    t.column :active, :boolean, default: true
    t.column :created_at, :datetime
    t.column :updated_at, :datetime
    t.column :notes, :text
    t.column :age, :integer
  end
end

def teardown_db
  if ActiveRecord::VERSION::MAJOR >= 5
    tables = ActiveRecord::Base.connection.data_sources
  else
    tables = ActiveRecord::Base.connection.tables
  end

  tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end
