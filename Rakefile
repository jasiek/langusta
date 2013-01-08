require "bundler/gem_tasks"
require "rake/testtask"

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts(e.message)
  $stderr.puts("Run `bundle install` to install missing gems")
  exit(e.status_code)
end

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test' << '.'
  test.pattern = 'test/test_*.rb'
  test.verbose = true
end

Rake::TestTask.new('test:quality') do |test|
  test.libs << 'test/quality' << 'lib' << '.'
  test.pattern = 'test/quality/test_*.rb'
  test.verbose = true
end

task :default => :test
