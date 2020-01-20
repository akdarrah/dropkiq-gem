require "test_helper"

class DropkiqDropMethodAnalyzerTest < Minitest::Test
  include TestDatabase
  include TestRecords

  def setup
    setup_test_scaffolding

    @class_analyzer = Dropkiq::DropClassAnalyzer.new(PersonDrop)
    @class_analyzer.analyze
  end

  def teardown
    teardown_test_scaffolding
  end

  # Column tests

  def test_correctly_identifies_string_column
    @analyzer = Dropkiq::DropMethodAnalyzer.new(@class_analyzer, :name)
    @analyzer.analyze

    expected = {"type" => Dropkiq::STRING_TYPE, "foreign_table_name" => nil}
    assert_equal expected, @analyzer.to_param['name']
  end

  def test_correctly_identifies_integer_column
    @analyzer = Dropkiq::DropMethodAnalyzer.new(@class_analyzer, :age)
    @analyzer.analyze

    expected = {"type" => Dropkiq::NUMERIC_TYPE, "foreign_table_name" => nil}
    assert_equal expected, @analyzer.to_param['age']
  end

  def test_correctly_identifies_boolean_column
    @analyzer = Dropkiq::DropMethodAnalyzer.new(@class_analyzer, :active)
    @analyzer.analyze

    expected = {"type" => Dropkiq::BOOLEAN_TYPE, "foreign_table_name" => nil}
    assert_equal expected, @analyzer.to_param['active']
  end

  def test_correctly_identifies_datetime_column
    @analyzer = Dropkiq::DropMethodAnalyzer.new(@class_analyzer, :created_at)
    @analyzer.analyze

    expected = {"type" => Dropkiq::DATE_TIME_TYPE, "foreign_table_name" => nil}
    assert_equal expected, @analyzer.to_param['created_at']
  end

  def test_correctly_identifies_date_column
    @analyzer = Dropkiq::DropMethodAnalyzer.new(@class_analyzer, :birthdate)
    @analyzer.analyze

    expected = {"type" => Dropkiq::DATE_TIME_TYPE, "foreign_table_name" => nil}
    assert_equal expected, @analyzer.to_param['birthdate']
  end

  def test_correctly_identifies_decimal_column
    @analyzer = Dropkiq::DropMethodAnalyzer.new(@class_analyzer, :net_worth)
    @analyzer.analyze

    expected = {"type" => Dropkiq::NUMERIC_TYPE, "foreign_table_name" => nil}
    assert_equal expected, @analyzer.to_param['net_worth']
  end

  def test_correctly_identifies_float_column
    @analyzer = Dropkiq::DropMethodAnalyzer.new(@class_analyzer, :height_in_miles)
    @analyzer.analyze

    expected = {"type" => Dropkiq::NUMERIC_TYPE, "foreign_table_name" => nil}
    assert_equal expected, @analyzer.to_param['height_in_miles']
  end

  def test_correctly_identifies_text_column
    @analyzer = Dropkiq::DropMethodAnalyzer.new(@class_analyzer, :notes)
    @analyzer.analyze

    expected = {"type" => Dropkiq::TEXT_TYPE, "foreign_table_name" => nil}
    assert_equal expected, @analyzer.to_param['notes']
  end

  def test_correctly_identifies_time_column
    @analyzer = Dropkiq::DropMethodAnalyzer.new(@class_analyzer, :favorite_time_of_day)
    @analyzer.analyze

    expected = {"type" => Dropkiq::DATE_TIME_TYPE, "foreign_table_name" => nil}
    assert_equal expected, @analyzer.to_param['favorite_time_of_day']
  end

  # Same as datetime
  def test_correctly_identifies_timestamp_column
    @analyzer = Dropkiq::DropMethodAnalyzer.new(@class_analyzer, :woke_up_at)
    @analyzer.analyze

    expected = {"type" => Dropkiq::DATE_TIME_TYPE, "foreign_table_name" => nil}
    assert_equal expected, @analyzer.to_param['woke_up_at']
  end

  def test_correctly_identifies_binary_column
    @analyzer = Dropkiq::DropMethodAnalyzer.new(@class_analyzer, :age_in_binary)
    @analyzer.analyze

    expected = {"type" => Dropkiq::NUMERIC_TYPE, "foreign_table_name" => nil}
    assert_equal expected, @analyzer.to_param['age_in_binary']
  end

  # Relationship Tests

  def test_correctly_identifies_belongs_to_relationship
    @analyzer = Dropkiq::DropMethodAnalyzer.new(@class_analyzer, :group)
    @analyzer.analyze

    expected = {"type" => Dropkiq::HAS_ONE_TYPE, "foreign_table_name" => "groups"}
    assert_equal expected, @analyzer.to_param['group']
  end

  def test_correctly_identifies_has_one_relationship
    @class_analyzer = Dropkiq::DropClassAnalyzer.new(GroupDrop)
    @class_analyzer.analyze

    @analyzer = Dropkiq::DropMethodAnalyzer.new(@class_analyzer, :owner)
    @analyzer.analyze

    expected = {"type" => Dropkiq::HAS_ONE_TYPE, "foreign_table_name" => "people"}
    assert_equal expected, @analyzer.to_param['owner']
  end

  def test_correctly_identifies_has_many_relationship
    @class_analyzer = Dropkiq::DropClassAnalyzer.new(GroupDrop)
    @class_analyzer.analyze

    @analyzer = Dropkiq::DropMethodAnalyzer.new(@class_analyzer, :people)
    @analyzer.analyze

    expected = {"type" => Dropkiq::HAS_MANY_TYPE, "foreign_table_name" => "people"}
    assert_equal expected, @analyzer.to_param['people']
  end

  def test_correctly_identifies_has_many_through_relationship
    @class_analyzer = Dropkiq::DropClassAnalyzer.new(TagDrop)
    @class_analyzer.analyze

    @analyzer = Dropkiq::DropMethodAnalyzer.new(@class_analyzer, :groups)
    @analyzer.analyze

    expected = {"type" => Dropkiq::HAS_MANY_TYPE, "foreign_table_name" => "groups"}
    assert_equal expected, @analyzer.to_param['groups']
  end

  def test_correctly_identifies_has_one_through_relationship
    @analyzer = Dropkiq::DropMethodAnalyzer.new(@class_analyzer, :group_owner)
    @analyzer.analyze

    expected = {"type" => Dropkiq::HAS_ONE_TYPE, "foreign_table_name" => "people"}
    assert_equal expected, @analyzer.to_param['group_owner']
  end

  def test_correctly_identifies_has_and_belongs_to_many_relationship
    @analyzer = Dropkiq::DropMethodAnalyzer.new(@class_analyzer, :tags)
    @analyzer.analyze

    expected = {"type" => Dropkiq::HAS_MANY_TYPE, "foreign_table_name" => "tags"}
    assert_equal expected, @analyzer.to_param['tags']
  end

  def test_correctly_identifies_has_and_belongs_to_many_relationship
    @analyzer = Dropkiq::DropMethodAnalyzer.new(@class_analyzer, :to_s)
    @analyzer.analyze

    expected = {"type" => Dropkiq::STRING_TYPE, "foreign_table_name" => nil}
    assert_equal expected, @analyzer.to_param['to_s']
  end

  def test_gracefully_handles_a_mistake_association
    @analyzer = Dropkiq::DropMethodAnalyzer.new(@class_analyzer, :unknown)
    @analyzer.analyze

    assert_nil @analyzer.dropkiq_type
    assert_nil @analyzer.foreign_table_name
    assert_equal @analyzer.to_param, {
      "unknown"=>{
        "type"=>"CHANGEME",
        "foreign_table_name"=>nil
      }
    }
  end
end
