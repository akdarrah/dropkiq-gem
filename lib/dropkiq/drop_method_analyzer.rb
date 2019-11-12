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
    end

    private

    def dropkiq_type_classifier
    end
  end
end
