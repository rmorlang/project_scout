require 'rubygems'
require 'bundler'
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "project_scout"
  gem.summary = %Q{scan directories to find the root directory of a project}
  gem.description = %Q{scan directories to find the root directory of a project}
  gem.email = "rick@lee-morlang.com"
  gem.homepage = "http://github.com/rleemorlang/project_scout"
  gem.authors = ["Rick Lee-Morlang"]
  gem.add_development_dependency "rspec", ">= 2.1.0"
  # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "project_scout #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
