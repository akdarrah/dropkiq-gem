require "test_helper"

class DropkiqDropClassAnalyzerTest < Minitest::Test
  include TestDatabase
  include TestRecords

  def setup
    setup_test_scaffolding

    @analyzer = Dropkiq::DropClassAnalyzer.new(PersonDrop)
    @analyzer.analyze
  end

  def teardown
    teardown_test_scaffolding
  end

  def test_finds_correct_active_record_model
    assert_equal Person, @analyzer.active_record_class
  end

  def test_finds_correct_table_name
    assert_equal Person.table_name, @analyzer.table_name
  end
end
