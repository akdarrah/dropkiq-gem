# Assumes that Drop class is named ModelNameDrop
# Assumes that Drop class has one argument that takes an instance
# Assumes that Drop class method will return same type if has the same name
# Assumes that ActiveRecord class has a normal primary key

module Dropkiq
  class DropClassAnalyzer
    attr_accessor :liquid_drop_class, :table_name,
      :active_record_class, :drop_method_params

    def initialize(liquid_drop_class)
      self.liquid_drop_class = liquid_drop_class
    end

    def analyze
      self.active_record_class = find_active_record_class
      begin
        self.table_name = active_record_class.table_name
      rescue Exception => e
        raise liquid_drop_class.inspect
      end
      self.drop_method_params = find_drop_method_params
    end

    def to_param
      {
        name: table_name,
        columns: drop_method_params
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

    def find_drop_method_params
      default_methods  = (Liquid::Drop.instance_methods + Object.instance_methods)
      instance_methods = (liquid_drop_class.instance_methods - default_methods)

      instance_methods.map do |method|
        analyzer = Dropkiq::DropMethodAnalyzer.new(self, method)
        analyzer.analyze
        analyzer.to_param
      end
    end
  end
end
