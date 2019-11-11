namespace :dropkiq do
  desc "Generate the fixture schema based on Liquid::Drop classes"
  task :schema do
    Dir.glob("#{Rails.root}#{Dropkiq::DEFAULT_DROP_PATH}/**/*.rb").each { |f| load f }
    klasses = Liquid::Drop.descendants - Dropkiq::DEFAULT_LIQUID_DROP_CLASSES
    puts klasses
  end
end
