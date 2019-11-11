require "test_helper"

class DropkiqTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Dropkiq::VERSION
  end
end
