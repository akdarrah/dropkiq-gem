# https://github.com/Shopify/liquid/pull/568
module LiquidMethods
  extend ActiveSupport::Concern

  module ClassMethods

    def liquid_methods(*allowed_methods)
      drop_class = eval "class #{self}::LiquidDropClass < Liquid::Drop; self; end"

      define_method :to_liquid do
        drop_class.new(self)
      end

      drop_class.class_eval do
        def initialize(object)
          @object = object
        end

        allowed_methods.each do |sym|
          define_method sym do
            @object.send sym
          end
        end
      end
    end
  end
end
