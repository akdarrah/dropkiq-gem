# https://coderwall.com/p/qhdhgw/adding-a-post-execution-hook-to-the-rails-db-migrate-task

namespace :db do
  def run_dropkiq_schema
    puts "\nRunning `bundle exec rake dropkiq:schema` ...\n\n"
    Rake::Task['dropkiq:schema'].invoke
  end

  task :migrate do
    run_dropkiq_schema
  end
end
