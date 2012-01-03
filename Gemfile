source :gemcutter

platform :mri_18 do
  gem "oniguruma", "1.1.0"
end

gem "yajl-ruby", "0.8.2", :require => 'yajl'

gem "bundler"
gem "jeweler"

group :test do
  gem "rcov"
  gem "mocha"
  gem "ruby-debug",   :platforms => :mri_18
  gem "ruby-debug19", :platforms => :mri_19 unless RUBY_VERSION == "1.9.3"
end
