require "test_helper"

class DropkiqDropAnalyzerTest < Minitest::Test
  def setup
    setup_test_scaffolding

    @analyzer = Dropkiq::DropClassAnalyzer.new(PersonDrop)
    @analyzer.analyze
  end

  def teardown
    teardown_test_scaffolding
  end

  # Column tests

  def test_correctly_identifies_string_column
    @column = @analyzer.drop_methods.detect{|data| data[:name] == :name}
    assert_equal :string, @column[:type]
  end

  def test_correctly_identifies_integer_column
    @column = @analyzer.drop_methods.detect{|data| data[:name] == :age}
    assert_equal :integer, @column[:type]
  end

  def test_correctly_identifies_boolean_column
    @column = @analyzer.drop_methods.detect{|data| data[:name] == :active}
    assert_equal :boolean, @column[:type]
  end

  def test_correctly_identifies_datetime_column
    @column = @analyzer.drop_methods.detect{|data| data[:name] == :created_at}
    assert_equal :datetime, @column[:type]
  end

  def test_columns_not_implemented_in_drop_class_are_hidden
    @column = @analyzer.drop_methods.detect{|data| data[:name] == :updated_at}
    assert_nil @column
  end

  # No Column tests

  def test_finds_type_for_method_without_a_column
    @column = @analyzer.drop_methods.detect{|data| data[:name] == :random_number}
    assert_equal :datetime, @column[:type]
  end
end
