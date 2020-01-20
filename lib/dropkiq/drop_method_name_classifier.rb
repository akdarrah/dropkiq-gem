module Dropkiq
  class DropMethodNameClassifier
    attr_accessor :drop_method

    def initialize(drop_method)
      self.drop_method = drop_method.to_s
    end

    def classify
      if numeric_type_match?
        Dropkiq::NUMERIC_TYPE
      elsif boolean_type_match?
        Dropkiq::BOOLEAN_TYPE
      elsif text_type_match?
        Dropkiq::TEXT_TYPE
      elsif string_type_match?
        Dropkiq::STRING_TYPE
      end
    end

    private

    def numeric_type_match?
      drop_method.ends_with?("_id") ||
        drop_method.ends_with?("_count")
    end

    def boolean_type_match?
      drop_method.ends_with?("?") ||
        drop_method.ends_with?("_present") ||
        drop_method.ends_with?("_changed")
    end

    def text_type_match?
      drop_method.ends_with?("description")
    end

    def string_type_match?
      drop_method.ends_with?("name") ||
        drop_method.ends_with?("password") ||
        drop_method.ends_with?("type") ||
        drop_method.ends_with?("title") ||
        drop_method.ends_with?("to_s") ||
        drop_method.ends_with?("to_string") ||
        drop_method.ends_with?("_url") ||
        drop_method.ends_with?("_email") ||
        drop_method.ends_with?("_partial") ||
        drop_method.ends_with?("_email_address") ||
        drop_method.ends_with?("_uuid")
    end
  end
end
