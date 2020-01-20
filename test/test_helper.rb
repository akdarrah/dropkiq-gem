$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "dropkiq"

require "test_database"
require "test_models"
require "test_drops"
require "test_records"

require "minitest/autorun"
require 'minitest/unit'
require 'mocha/minitest'

def setup_test_scaffolding
  setup_db
  setup_records
end

def teardown_test_scaffolding
  teardown_db
end
