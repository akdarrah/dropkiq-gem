require "test_helper"

class DropkiqDropAnalyzerTest < Minitest::Test
  class PersonDrop < Liquid::Drop
    def initialize(person)
      @person = person
    end

    def name
      @person["name"]
    end
  end

  class Person < ActiveRecord::Base
  end

  def setup
    setup_db

    @person = Person.create!({
      name: "John Doe",
      active: true,
      notes: "A banana is an edible fruit – botanically a berry – produced by several kinds of large herbaceous flowering plants in the genus Musa. In some countries, bananas used for cooking may be called \"plantains\", distinguishing them from dessert bananas. Wikipedia",
      age: 34
    })
    @person_drop = PersonDrop.new(@person)
  end

  def teardown
    teardown_db
  end

  def test_finds_correct_active_record_model
    @analyzer = Dropkiq::DropAnalyzer.new(PersonDrop)
    @analyzer.analyze

    assert_equal Person, @analyzer.active_record_class
  end
end
