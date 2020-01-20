module Dropkiq
  class DropClassAnalyzer
    attr_accessor :liquid_drop_class, :table_name,
      :active_record_class, :drop_method_params

    def initialize(liquid_drop_class)
      self.liquid_drop_class = liquid_drop_class
    end

    def analyze
      self.active_record_class = find_active_record_class
      self.active_record_class ||= find_active_record_class_from_shim

      if active_record_class.blank?
        puts "WARNING: No ActiveRecord Class found for #{liquid_drop_class.name} (skipping)"
        return
      end

      self.table_name = active_record_class.table_name
      self.drop_method_params = find_drop_method_params
    end

    def to_param
      return {} if active_record_class.blank?

      {
        "#{table_name}" => {
          "methods" => drop_method_params
        }
      }
    end

    private

    def find_active_record_class
      namespaces = liquid_drop_class.name.split("::")
      class_name = namespaces.pop
      non_drop   = class_name.gsub('Drop', '')

      namespaces.push(non_drop).join("::").constantize
    rescue NameError
    end

    # https://github.com/Shopify/liquid/pull/568
    def find_active_record_class_from_shim
      namespaces = liquid_drop_class.name.split("::")
      namespaces[0..-2].join("::").constantize
    rescue NameError
    end

    def find_drop_method_params
      default_methods  = (Liquid::Drop.instance_methods + Object.instance_methods)
      instance_methods = (liquid_drop_class.instance_methods - default_methods)

      instance_methods.inject({}) do |hash, method|
        analyzer = Dropkiq::DropMethodAnalyzer.new(self, method)
        analyzer.analyze
        hash.merge!(analyzer.to_param)
      end.sort_by { |key| key }.to_h
    end
  end
end
