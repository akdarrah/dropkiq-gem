namespace :dropkiq do
  desc "Generate the fixture schema based on Liquid::Drop classes"
  task :schema do
    Dir.glob("#{Rails.root}#{Dropkiq::DEFAULT_DROP_PATH}/**/*.rb").each { |f| load f }
    klasses = Liquid::Drop.descendants - Dropkiq::DEFAULT_LIQUID_DROP_CLASSES

    schema = klasses.map do |klass|
      default_methods = (Liquid::Drop.instance_methods + Object.instance_methods)
      methods = (klass.instance_methods - default_methods)

      active_record_klass = begin
        klass.name.gsub('Drop', '').constantize
      rescue NameError
      end

      if active_record_klass.present?
        Event.columns_hash["name"].type
      end

      {
        name: klass,
        columns: methods
      }
    end

    puts schema
  end
end
