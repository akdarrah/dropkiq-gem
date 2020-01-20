require "test_helper"

class DropMethodNameClassifierTest < Minitest::Test
  def setup
  end

  # No Match

  def test_ends_with_underscore_id
    assert_nil Dropkiq::DropMethodNameClassifier.new("something_crazy").classify
  end

  # Numeric

  def test_ends_with_underscore_id
    assert_equal Dropkiq::NUMERIC_TYPE, Dropkiq::DropMethodNameClassifier.new("test_id").classify
  end

  def test_ends_with_underscore_count
    assert_equal Dropkiq::NUMERIC_TYPE, Dropkiq::DropMethodNameClassifier.new("test_count").classify
  end

  # Boolean

  def test_ends_with_anything_then_question_mark
    assert_equal Dropkiq::BOOLEAN_TYPE, Dropkiq::DropMethodNameClassifier.new("test?").classify
  end

  def test_ends_with_underscore_present
    assert_equal Dropkiq::BOOLEAN_TYPE, Dropkiq::DropMethodNameClassifier.new("test_present").classify
  end

  def test_ends_with_underscore_changed
    assert_equal Dropkiq::BOOLEAN_TYPE, Dropkiq::DropMethodNameClassifier.new("test_changed").classify
  end

  # Text

  def test_ends_with_description
    assert_equal Dropkiq::TEXT_TYPE, Dropkiq::DropMethodNameClassifier.new("test_description").classify
  end

  def test_matches_with_description
    assert_equal Dropkiq::TEXT_TYPE, Dropkiq::DropMethodNameClassifier.new("description").classify
  end

  # String

  def test_ends_with_name
    assert_equal Dropkiq::STRING_TYPE, Dropkiq::DropMethodNameClassifier.new("test_name").classify
  end

  def test_matches_with_name
    assert_equal Dropkiq::STRING_TYPE, Dropkiq::DropMethodNameClassifier.new("name").classify
  end

  def test_ends_with_password
    assert_equal Dropkiq::STRING_TYPE, Dropkiq::DropMethodNameClassifier.new("test_password").classify
  end

  def test_matches_with_password
    assert_equal Dropkiq::STRING_TYPE, Dropkiq::DropMethodNameClassifier.new("password").classify
  end

  def test_ends_with_type
    assert_equal Dropkiq::STRING_TYPE, Dropkiq::DropMethodNameClassifier.new("test_type").classify
  end

  def test_matches_with_type
    assert_equal Dropkiq::STRING_TYPE, Dropkiq::DropMethodNameClassifier.new("type").classify
  end

  def test_ends_with_title
    assert_equal Dropkiq::STRING_TYPE, Dropkiq::DropMethodNameClassifier.new("test_title").classify
  end

  def test_matches_with_title
    assert_equal Dropkiq::STRING_TYPE, Dropkiq::DropMethodNameClassifier.new("title").classify
  end

  def test_matches_with_underscore_to_s
    assert_equal Dropkiq::STRING_TYPE, Dropkiq::DropMethodNameClassifier.new("to_s").classify
  end

  def test_ends_with_underscore_to_s
    assert_equal Dropkiq::STRING_TYPE, Dropkiq::DropMethodNameClassifier.new("test_to_s").classify
  end

  def test_ends_with_to_string
    assert_equal Dropkiq::STRING_TYPE, Dropkiq::DropMethodNameClassifier.new("test_to_string").classify
  end

  def test_matches_with_to_string
    assert_equal Dropkiq::STRING_TYPE, Dropkiq::DropMethodNameClassifier.new("to_string").classify
  end

  def test_ends_with_underscore_url
    assert_equal Dropkiq::STRING_TYPE, Dropkiq::DropMethodNameClassifier.new("test_url").classify
  end

  def test_ends_with_underscore_email
    assert_equal Dropkiq::STRING_TYPE, Dropkiq::DropMethodNameClassifier.new("test_email").classify
  end

  def test_ends_with_underscore_partial
    assert_equal Dropkiq::STRING_TYPE, Dropkiq::DropMethodNameClassifier.new("test_partial").classify
  end

  def test_ends_with_underscore_email_address
    assert_equal Dropkiq::STRING_TYPE, Dropkiq::DropMethodNameClassifier.new("test_email_address").classify
  end

  def test_ends_with_underscore_uuid
    assert_equal Dropkiq::STRING_TYPE, Dropkiq::DropMethodNameClassifier.new("test_uuid").classify
  end
end
