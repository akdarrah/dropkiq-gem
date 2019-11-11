# Assumes that Drop class is named ModelNameDrop
# Assumes that Drop class has one argument that takes an instance

module Dropkiq
  class DropAnalyzer
    attr_accessor :liquid_drop_class,
      :active_record_class

    def initialize(liquid_drop_class)
      self.liquid_drop_class = liquid_drop_class
    end

    def analyze
      self.active_record_class = find_active_record_class
    end

    private

    def find_active_record_class
      namespaces = liquid_drop_class.name.split("::")
      class_name = namespaces.pop
      non_drop   = class_name.gsub('Drop', '')

      namespaces.push(non_drop).join("::").constantize
    rescue NameError
    end
  end
end
