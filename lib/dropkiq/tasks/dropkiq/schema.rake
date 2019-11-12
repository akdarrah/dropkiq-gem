namespace :dropkiq do
  desc "Generate the fixture schema based on Liquid::Drop classes"
  task :schema do
    require "#{Rails.root}/config/environment.rb"
    binding.pry

    existing_schema_yaml = File.read("#{Rails.root}/db/dropkiq_schema.yaml")
    existing_schema = (existing_schema_yaml.present? ? YAML.load(existing_schema_yaml) : {})

    klasses = Liquid::Drop.descendants - Dropkiq::DEFAULT_LIQUID_DROP_CLASSES
    schema = klasses.map do |klass|
      analyzer = Dropkiq::DropClassAnalyzer.new(klass)
      analyzer.analyze
      analyzer.to_param
    end

    open("#{Rails.root}/db/dropkiq_schema.yaml", 'w') { |f|
      f.puts schema.to_yaml
    }
  end
end
