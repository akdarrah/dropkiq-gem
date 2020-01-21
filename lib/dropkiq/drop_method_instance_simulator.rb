module Dropkiq
  class DropMethodInstanceSimulator
    attr_accessor :drop_method, :sample_drop

    def initialize(drop_method, sample_drop=nil)
      self.drop_method = drop_method.to_s
      self.sample_drop = sample_drop
    end

    def classify
      value = begin
        sample_drop.try(drop_method)
      rescue
      end

      ruby_data_type_to_dropkiq_type(value)
    end

    private

    def ruby_data_type_to_dropkiq_type(value)
      case value
      when NilClass
      when TrueClass
        Dropkiq::BOOLEAN_TYPE
      when FalseClass
        Dropkiq::BOOLEAN_TYPE
      when String
        Dropkiq::STRING_TYPE
      when Symbol
        Dropkiq::STRING_TYPE
      when Numeric
        Dropkiq::NUMERIC_TYPE
      when Date
        Dropkiq::DATE_TIME_TYPE
      when Time
        Dropkiq::DATE_TIME_TYPE
      when DateTime
        Dropkiq::DATE_TIME_TYPE
      else
      end
    end
  end
end
