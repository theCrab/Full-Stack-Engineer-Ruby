require 'dm-migrations'
require './rake_spec'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)
task default: :spec

desc 'List all routes'
task :routes do
  puts `grep '^[get|post|put|delete].*do$' routes/*.rb | sed 's/ do$//'`
end

desc 'Auto migrates the database'
task :migrate do
  require './app'
  DataMapper.auto_migrate!
end

desc 'Upgrades the database. This will wipe it clean'
task :upgrade do
  require './app'
  DataMapper.auto_upgrade!
end
