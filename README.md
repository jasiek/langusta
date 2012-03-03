# langusta

Langusta is a language detection library based on a method designed and implemented by Nakatani Shuyo. This work is almost a direct 1-to-1 port of the original Java library which can be found at: http://code.google.com/p/language-detection.

For more information about the method (naive bayesian classification), have a look at this presentation: http://www.slideshare.net/shuyo/language-detection-library-for-java. This implementation uses some resources from the original library, specifically the language profiles.

## Build status

[![Build Status](https://secure.travis-ci.org/jasiek/langusta.png?branch=master)](http://travis-ci.org/jasiek/langusta)

## Runtime dependencies

* oniguruma - regular expressions swiss army knife (only required for 1.8.7)
* yajl-ruby - a quick and elegant JSON parser

## Usage

The simplest way to use this library is to use the facade provided with this package.

```ruby
require 'langusta'
facade = Langusta::LanguageDetectionFacade.new
facade.detect('zażółć gęślą jaźń') #=> 'pl'
```

If you don't need all 49 profiles, you can boost your detection speed and reduce memory consumption by writing your own facade-like class.

## Compatibility

* Ruby 1.8.7
* Ruby 1.9.2
* Ruby 1.9.3

## Caveats

Langusta is a memory hog - 49 profiles will take up about 80MB of RAM.

## Contributing to langusta
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011, 2012 Jan Szumiec. See LICENSE.txt for further details.

