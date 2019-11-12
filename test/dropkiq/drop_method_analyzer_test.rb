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

    assert_equal Dropkiq::STRING_TYPE, @analyzer.dropkiq_type
  end

  def test_correctly_identifies_integer_column
    @analyzer = Dropkiq::DropMethodAnalyzer.new(@class_analyzer, :age)
    @analyzer.analyze

    assert_equal Dropkiq::NUMERIC_TYPE, @analyzer.dropkiq_type
  end

  def test_correctly_identifies_boolean_column
    @analyzer = Dropkiq::DropMethodAnalyzer.new(@class_analyzer, :active)
    @analyzer.analyze

    assert_equal Dropkiq::BOOLEAN_TYPE, @analyzer.dropkiq_type
  end

  def test_correctly_identifies_datetime_column
    @analyzer = Dropkiq::DropMethodAnalyzer.new(@class_analyzer, :created_at)
    @analyzer.analyze

    assert_equal Dropkiq::DATE_TIME_TYPE, @analyzer.dropkiq_type
  end

  def test_correctly_identifies_date_column
    @analyzer = Dropkiq::DropMethodAnalyzer.new(@class_analyzer, :birthdate)
    @analyzer.analyze

    assert_equal Dropkiq::DATE_TIME_TYPE, @analyzer.dropkiq_type
  end

  def test_correctly_identifies_decimal_column
    @analyzer = Dropkiq::DropMethodAnalyzer.new(@class_analyzer, :net_worth)
    @analyzer.analyze

    assert_equal Dropkiq::NUMERIC_TYPE, @analyzer.dropkiq_type
  end

  def test_correctly_identifies_float_column
    @analyzer = Dropkiq::DropMethodAnalyzer.new(@class_analyzer, :height_in_miles)
    @analyzer.analyze

    assert_equal Dropkiq::NUMERIC_TYPE, @analyzer.dropkiq_type
  end

  def test_correctly_identifies_text_column
    @analyzer = Dropkiq::DropMethodAnalyzer.new(@class_analyzer, :notes)
    @analyzer.analyze

    assert_equal Dropkiq::TEXT_TYPE, @analyzer.dropkiq_type
  end

  def test_correctly_identifies_time_column
    @analyzer = Dropkiq::DropMethodAnalyzer.new(@class_analyzer, :favorite_time_of_day)
    @analyzer.analyze

    assert_equal Dropkiq::DATE_TIME_TYPE, @analyzer.dropkiq_type
  end

  # Same as datetime
  def test_correctly_identifies_timestamp_column
    @analyzer = Dropkiq::DropMethodAnalyzer.new(@class_analyzer, :woke_up_at)
    @analyzer.analyze

    assert_equal Dropkiq::DATE_TIME_TYPE, @analyzer.dropkiq_type
  end

  def test_correctly_identifies_binary_column
    @analyzer = Dropkiq::DropMethodAnalyzer.new(@class_analyzer, :age_in_binary)
    @analyzer.analyze

    assert_equal Dropkiq::NUMERIC_TYPE, @analyzer.dropkiq_type
  end

  # Relationship Tests

  def test_correctly_identifies_belongs_to_relationship
    @analyzer = Dropkiq::DropMethodAnalyzer.new(@class_analyzer, :group)
    @analyzer.analyze

    assert_equal Dropkiq::HAS_ONE_TYPE, @analyzer.dropkiq_type
  end

  def test_correctly_identifies_has_one_relationship
    @class_analyzer = Dropkiq::DropClassAnalyzer.new(GroupDrop)
    @class_analyzer.analyze

    @analyzer = Dropkiq::DropMethodAnalyzer.new(@class_analyzer, :owner)
    @analyzer.analyze

    assert_equal Dropkiq::HAS_ONE_TYPE, @analyzer.dropkiq_type
  end

  def test_correctly_identifies_has_many_relationship
    @class_analyzer = Dropkiq::DropClassAnalyzer.new(GroupDrop)
    @class_analyzer.analyze

    @analyzer = Dropkiq::DropMethodAnalyzer.new(@class_analyzer, :people)
    @analyzer.analyze

    assert_equal Dropkiq::HAS_MANY_TYPE, @analyzer.dropkiq_type
  end

  def test_correctly_identifies_has_many_through_relationship
    @class_analyzer = Dropkiq::DropClassAnalyzer.new(TagDrop)
    @class_analyzer.analyze

    @analyzer = Dropkiq::DropMethodAnalyzer.new(@class_analyzer, :groups)
    @analyzer.analyze

    assert_equal Dropkiq::HAS_MANY_TYPE, @analyzer.dropkiq_type
  end

  def test_correctly_identifies_has_one_through_relationship
    @analyzer = Dropkiq::DropMethodAnalyzer.new(@class_analyzer, :group_owner)
    @analyzer.analyze

    assert_equal Dropkiq::HAS_ONE_TYPE, @analyzer.dropkiq_type
  end

  def test_correctly_identifies_has_and_belongs_to_many_relationship
    @analyzer = Dropkiq::DropMethodAnalyzer.new(@class_analyzer, :tags)
    @analyzer.analyze

    assert_equal Dropkiq::HAS_MANY_TYPE, @analyzer.dropkiq_type
  end
end
