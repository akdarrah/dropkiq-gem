require "test_helper"

class DropkiqDropAnalyzerTest < Minitest::Test
  class PersonDrop < Liquid::Drop
    def initialize(person)
      @person = person
    end

    def name
      @person["name"]
    end

    def age
      @person["age"]
    end

    def active
      @person["active"]
    end

    def created_at
      @person["created_at"]
    end

    def random_number
      rand(1..10)
    end
  end

  class Person < ActiveRecord::Base
    has_many :taggings, as: :taggable
    has_many :tags, through: :taggings

    belongs_to :group
    has_one :group_owner,
      through: :group,
      source: :owner
  end

  class Tagging < ActiveRecord::Base
    belongs_to :taggable, polymorphic: true
    belongs_to :tag
  end

  class Tag < ActiveRecord::Base
    has_many :taggings
  end

  class Group < ActiveRecord::Base
    has_many :people
    has_one :owner, class_name: "Person"
  end

  def setup
    setup_db

    @person = Person.create!({
      name: "John Doe",
      active: true,
      notes: "A banana is an edible fruit – botanically a berry – produced by several kinds of large herbaceous flowering plants in the genus Musa. In some countries, bananas used for cooking may be called \"plantains\", distinguishing them from dessert bananas. Wikipedia",
      age: 34
    })

    @group = Group.create!(name: "Chiquita Banana", owner: @person)
    @group.people << @person

    @banana_tag = Tag.create!({name: "Banana"})
    @orange_tag = Tag.create!({name: "Orange"})

    @person.tags << @banana_tag
    @person.tags << @orange_tag

    @person_drop = PersonDrop.new(@person)

    @analyzer = Dropkiq::DropAnalyzer.new(PersonDrop)
    @analyzer.analyze
  end

  def teardown
    teardown_db
  end

  def test_finds_correct_active_record_model
    assert_equal Person, @analyzer.active_record_class
  end

  def test_finds_correct_table_name
    assert_equal Person.table_name, @analyzer.table_name
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
