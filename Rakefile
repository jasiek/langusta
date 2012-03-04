require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "langusta"
  gem.homepage = "http://github.com/jasiek/langusta"
  gem.license = "Apache 2.0"
  gem.summary = %Q{Language detection library based on http://code.google.com/p/language-detection/.}
  gem.description = %Q{Highly accurate language detection library, uses naive bayesian filter.}
  gem.email = "jan.szumiec@gmail.com"
  gem.authors = ["Jan Szumiec"]
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test' << '.'
  test.pattern = 'test/test_*.rb'
  test.verbose = true
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "langusta #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Rake::TestTask.new('test:quality') do |test|
  test.libs << 'test/quality' << 'lib' << '.'
  test.pattern = 'test/quality/test_*.rb'
  test.verbose = true
end
