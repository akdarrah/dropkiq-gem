module Dropkiq
  class DropMethodAnalyzer
    CHANGEME = "CHANGEME"

    attr_accessor :drop_class_analyzer, :drop_method,
      :dropkiq_type, :foreign_table_name, :sample_drop

    delegate :active_record_class, to: :drop_class_analyzer

    def initialize(drop_class_analyzer, drop_method, sample_drop=nil)
      self.drop_class_analyzer = drop_class_analyzer
      self.drop_method = drop_method
      self.sample_drop = sample_drop
    end

    def analyze
      self.dropkiq_type = if is_relationship?
        relationship_to_dropkiq_type_classifier
      elsif is_column?
        column_to_dropkiq_type_classifier
      else
        Dropkiq::DropMethodNameClassifier.new(drop_method).classify ||
          Dropkiq::DropMethodInstanceSimulator.new(drop_method, sample_drop).classify
      end
    end

    def to_param
      {
        "#{drop_method}" => {
          "type"               => (dropkiq_type.presence || CHANGEME),
          "foreign_table_name" => foreign_table_name
        }
      }
    end

    private

    def reflect_on_association_value
      active_record_class.reflect_on_association(drop_method)
    end

    def is_relationship?
      reflect_on_association_value.present?
    end

    def relationship_to_dropkiq_type_classifier
      reflection = reflect_on_association_value

      begin
        self.foreign_table_name = reflection.class_name.constantize.table_name
      rescue
        puts "WARNING: Could not find #{drop_method} on #{active_record_class.name}"
        return
      end

      case reflection
      when ActiveRecord::Reflection::BelongsToReflection
        Dropkiq::HAS_ONE_TYPE
      when ActiveRecord::Reflection::HasOneReflection
        Dropkiq::HAS_ONE_TYPE
      when ActiveRecord::Reflection::HasManyReflection
        Dropkiq::HAS_MANY_TYPE
      when ActiveRecord::Reflection::ThroughReflection
        if reflection.send(:delegate_reflection).is_a?(ActiveRecord::Reflection::HasOneReflection)
          Dropkiq::HAS_ONE_TYPE
        else
          Dropkiq::HAS_MANY_TYPE
        end
      when ActiveRecord::Reflection::HasAndBelongsToManyReflection
        Dropkiq::HAS_MANY_TYPE
      end
    end

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
      when :date
        Dropkiq::DATE_TIME_TYPE
      when :decimal
        Dropkiq::NUMERIC_TYPE
      when :float
        Dropkiq::NUMERIC_TYPE
      when :text
        Dropkiq::TEXT_TYPE
      when :time
        Dropkiq::DATE_TIME_TYPE
      when :binary
        Dropkiq::NUMERIC_TYPE
      end
    end
  end
end
