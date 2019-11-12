namespace :dropkiq do
  desc "Generate the fixture schema based on Liquid::Drop classes"
  task :schema do
    require "#{Rails.root}/config/environment.rb"

    existing_schema_yaml = begin
      File.read("#{Rails.root}/db/dropkiq_schema.yaml")
    rescue Errno::ENOENT
    end
    existing_schema = (existing_schema_yaml.present? ? YAML.load(existing_schema_yaml) : {})

    klasses = Liquid::Drop.descendants - Dropkiq::DEFAULT_LIQUID_DROP_CLASSES
    schema = klasses.inject({}) do |schema, klass|
      analyzer = Dropkiq::DropClassAnalyzer.new(klass)
      analyzer.analyze
      schema.merge!(analyzer.to_param)
    end

    binding.pry

    open("#{Rails.root}/db/dropkiq_schema.yaml", 'w') { |f|
      f.puts schema.to_yaml
    }
  end
end
