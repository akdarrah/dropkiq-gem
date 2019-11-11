require "test_helper"

class DropkiqDropClassTest < Minitest::Test
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
  end

  def teardown
    teardown_db
  end

  def test_failure
    assert false
  end
end
