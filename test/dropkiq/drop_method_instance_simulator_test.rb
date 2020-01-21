require "test_helper"

class DropMethodInstanceSimulatorTest < Minitest::Test
  include TestDatabase
  include TestRecords

  def setup
    setup_test_scaffolding
    @sample_drop = PersonDrop.new(Person.first)
  end

  def teardown
    teardown_test_scaffolding
  end

  def test_when_no_drop_sample
    assert_nil Dropkiq::DropMethodInstanceSimulator.new("example", nil).classify
  end

  def test_when_method_returns_nil
    assert_nil Dropkiq::DropMethodInstanceSimulator.new("nil", @sample_drop).classify
  end

  def test_when_unknown_value
    assert_nil Dropkiq::DropMethodInstanceSimulator.new("unknown", @sample_drop).classify
  end

  def test_when_method_returns_true
    assert_equal Dropkiq::BOOLEAN_TYPE,
      Dropkiq::DropMethodInstanceSimulator.new("true", @sample_drop).classify
  end

  def test_when_method_returns_false
    assert_equal Dropkiq::BOOLEAN_TYPE,
      Dropkiq::DropMethodInstanceSimulator.new("false", @sample_drop).classify
  end

  def test_when_method_returns_string
    assert_equal Dropkiq::STRING_TYPE,
      Dropkiq::DropMethodInstanceSimulator.new("string", @sample_drop).classify
  end

  def test_when_method_returns_symbol
    assert_equal Dropkiq::STRING_TYPE,
      Dropkiq::DropMethodInstanceSimulator.new("symbol", @sample_drop).classify
  end

  def test_when_method_returns_integer
    assert_equal Dropkiq::NUMERIC_TYPE,
      Dropkiq::DropMethodInstanceSimulator.new("integer", @sample_drop).classify
  end

  def test_when_method_returns_float
    assert_equal Dropkiq::NUMERIC_TYPE,
      Dropkiq::DropMethodInstanceSimulator.new("float", @sample_drop).classify
  end

  def test_when_method_returns_datetime
    assert_equal Dropkiq::DATE_TIME_TYPE,
      Dropkiq::DropMethodInstanceSimulator.new("datetime", @sample_drop).classify
  end

  def test_when_method_returns_date
    assert_equal Dropkiq::DATE_TIME_TYPE,
      Dropkiq::DropMethodInstanceSimulator.new("date", @sample_drop).classify
  end

  def test_when_method_returns_time
    assert_equal Dropkiq::DATE_TIME_TYPE,
      Dropkiq::DropMethodInstanceSimulator.new("time", @sample_drop).classify
  end
end
