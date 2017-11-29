# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'langusta/version'

Gem::Specification.new do |gem|
  gem.name          = "langusta"
  gem.version       = Langusta::VERSION
  gem.authors       = ["Jan Szumiec"]
  gem.email         = ["jan.szumiec@gmail.com"]
  gem.description   = %q{Highly accurate language detection library, uses naive bayesian filter.}
  gem.summary       = %q{Language detection library based on http://code.google.com/p/language-detection/.}
  gem.homepage      = "http://jasiek.github.com/langusta/"

  gem.files         = Dir["*.md", "*.txt", "bin/*", "data/*", "{lib}/**/*.rb", "profiles/*", "test/**/*"]
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency("oniguruma", ["= 1.1.0"]) if RUBY_VERSION < "1.9"
  gem.add_runtime_dependency("yajl-ruby", ["= 1.3.1"])
  gem.add_development_dependency("mocha")
  gem.add_development_dependency("rake")
  gem.add_development_dependency("test-unit") if RUBY_VERSION >= "2.2"
end
