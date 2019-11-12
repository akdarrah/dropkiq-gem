# Assumes that Drop class is named ModelNameDrop
# Assumes that Drop class has one argument that takes an instance
# Assumes that Drop class method will return same type if has the same name

module Dropkiq
  class DropClassAnalyzer
    attr_accessor :liquid_drop_class, :table_name,
      :active_record_class, :drop_methods

    def initialize(liquid_drop_class)
      self.liquid_drop_class = liquid_drop_class
    end

    def analyze
      self.active_record_class = find_active_record_class
      self.table_name = active_record_class.table_name
      self.drop_methods = find_drop_methods
    end

    private

    def find_active_record_class
      namespaces = liquid_drop_class.name.split("::")
      class_name = namespaces.pop
      non_drop   = class_name.gsub('Drop', '')

      namespaces.push(non_drop).join("::").constantize
    rescue NameError
    end

    def find_drop_methods
      default_methods  = (Liquid::Drop.instance_methods + Object.instance_methods)
      instance_methods = (liquid_drop_class.instance_methods - default_methods)
      columns_hash     = active_record_class.columns_hash

      instance_methods.map do |method|
        Dropkiq::DropMethodAnalyzer.new(self, method).analyze
      end
    end
  end
end
