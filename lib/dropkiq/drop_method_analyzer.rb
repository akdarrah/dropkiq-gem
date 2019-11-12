module Dropkiq
  class DropMethodAnalyzer
    attr_accessor :drop_class_analyzer, :drop_method,
      :dropkiq_type

    delegate :active_record_class, to: :drop_class_analyzer

    def initialize(drop_class_analyzer, drop_method)
      self.drop_class_analyzer = drop_class_analyzer
      self.drop_method = drop_method
    end

    def analyze
      self.dropkiq_type = if is_column?
        column_to_dropkiq_type_classifier
      end
    end

    private

    def columns_hash_value
      active_record_class.columns_hash[drop_method.to_s]
    end

    def is_column?
      columns_hash_value.present?
    end

    def column_to_dropkiq_type_classifier
      case columns_hash_value.type
      when :string
        Dropkiq::STRING_TYPE
      when :integer
        Dropkiq::NUMERIC_TYPE
      when :boolean
        Dropkiq::BOOLEAN_TYPE
      when :datetime
        Dropkiq::DATE_TIME_TYPE
      end
    end
  end
end
