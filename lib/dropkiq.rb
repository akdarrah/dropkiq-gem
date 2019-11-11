require "dropkiq/version"
require "dropkiq/constants"

module Dropkiq
  class Error < StandardError; end

  require 'dropkiq/railtie' if defined?(Rails)
end
