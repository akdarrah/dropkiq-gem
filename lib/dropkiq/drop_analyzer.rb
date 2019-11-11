module Dropkiq
  class DropAnalyzer
    attr_accessor :liquid_drop_klass

    def initialize(liquid_drop_klass)
      self.liquid_drop_klass = liquid_drop_klass
    end
  end
end
