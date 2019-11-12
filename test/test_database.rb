db_config = YAML.load_file(File.expand_path("../database.yml", __FILE__)).fetch(ENV["DB"] || "sqlite")
ActiveRecord::Base.establish_connection(db_config)
ActiveRecord::Schema.verbose = false

module TestDatabase
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
      t.column :group_id, :integer
      t.column :birthdate, :date
      t.column :net_worth, :decimal, precision: 5, scale: 2
      t.column :height_in_miles, :float, precision: 5, scale: 2
      t.column :favorite_time_of_day, :time
      t.column :woke_up_at, :timestamp
    end

    ActiveRecord::Base.connection.create_table :people_tags do |t|
      t.column :tag_id, :integer
      t.column :person_id, :integer
    end

    ActiveRecord::Base.connection.create_table :tags do |t|
      t.column :name, :string
    end

    ActiveRecord::Base.connection.create_table :groups do |t|
      t.column :name, :string
      t.column :owner_id, :integer
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
end
