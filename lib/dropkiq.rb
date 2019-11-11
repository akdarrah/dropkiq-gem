require "dropkiq/version"

module Dropkiq
  class Error < StandardError; end

  require 'dropkiq/railtie' if defined?(Rails)
end
