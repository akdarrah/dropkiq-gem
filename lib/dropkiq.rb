require "dropkiq/version"
require "dropkiq/constants"

require "dropkiq/drop_class"

require 'dropkiq/railtie' if defined?(Rails)

module Dropkiq
  class Error < StandardError; end
end
