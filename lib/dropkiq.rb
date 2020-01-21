require "pry"
require "liquid"
require 'active_record'

require "dropkiq/version"
require "dropkiq/constants"

require "dropkiq/drop_class_analyzer"
require "dropkiq/drop_method_analyzer"
require "dropkiq/drop_method_name_classifier"
require "dropkiq/drop_method_instance_simulator"
require 'dropkiq/railtie' if defined?(Rails)

module Dropkiq
  class Error < StandardError; end
end
