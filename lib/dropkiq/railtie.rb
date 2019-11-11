# lib/railtie.rb
require 'dropkiq'
require 'rails'

module Dropkiq
  class Railtie < Rails::Railtie
    railtie_name :dropkiq

    rake_tasks do
      path = File.expand_path(__dir__)
      Dir.glob("#{path}/tasks/**/*.rake").each { |f| load f }
    end
  end
end
