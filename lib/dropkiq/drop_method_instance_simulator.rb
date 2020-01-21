module Dropkiq
  class DropMethodInstanceSimulator
    attr_accessor :drop_method, :sample_drop
    attr_accessor :dropkiq_type, :foreign_table_name

    def initialize(drop_method, sample_drop=nil)
      self.drop_method = drop_method.to_s
      self.sample_drop = sample_drop
    end

    def classify
      value = begin
        sample_drop.try(drop_method)
      rescue
      end

      self.dropkiq_type = ruby_data_type_to_dropkiq_type(value)
      self.dropkiq_type ||= test_for_relationship(value)

      self
    end

    private

    def test_for_relationship(value)
      if value.is_a?(ActiveRecord::Base)
        self.foreign_table_name = value.class.table_name
        return Dropkiq::HAS_ONE_TYPE
      elsif value.respond_to?(:first) && value.first.is_a?(ActiveRecord::Base)
        self.foreign_table_name = value.first.class.table_name
        return Dropkiq::HAS_MANY_TYPE
      end
    end

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
