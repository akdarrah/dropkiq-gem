namespace :dropkiq do
  desc "Generate the fixture schema based on Liquid::Drop classes"
  task :schema do
    require "#{Rails.root}/config/environment.rb"
    Dir.glob("#{Rails.root}#{Dropkiq::DEFAULT_DROP_PATH}/**/*.rb").each { |f| load f }

    klasses = Liquid::Drop.descendants - Dropkiq::DEFAULT_LIQUID_DROP_CLASSES

    schema = klasses.map do |klass|
      analyzer = Dropkiq::DropClassAnalyzer.new(klass)
      analyzer.analyze
      analyzer.to_param
    end

    puts schema
  end
end
