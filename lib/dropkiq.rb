require "liquid"
require 'active_record'

require "dropkiq/version"
require "dropkiq/constants"

require "dropkiq/drop_class_analyzer"
require "dropkiq/drop_method_analyzer"
require "dropkiq/drop_method_name_classifier"
require "dropkiq/drop_method_instance_simulator"
require 'dropkiq/railtie' if defined?(Rails)

Dir[File.join(File.dirname(__FILE__), 'tasks', '**/*.rake')].each do |rake|
  load rake
end

module Dropkiq
  class Error < StandardError; end
end
