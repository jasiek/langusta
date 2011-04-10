$: << File.expand_path(File.dirname(__FILE__))

require 'rubygems'
require 'bundler'
Bundler.setup

require 'optparse'
require 'iconv'

# Required gems
require 'oniguruma'
require 'yajl'

module Langusta
  VERSION = '0.1.1'

  autoload :RegexHelper, 'langusta/regex_helper'
  autoload :UCS2String, 'langusta/ucs2_string'
  autoload :Language, 'langusta/language'
  autoload :LangProfile, 'langusta/lang_profile'
  autoload :Detector, 'langusta/detector'
  autoload :JavaPropertyReader, 'langusta/java_property_reader'
  autoload :UnicodeBlock, 'langusta/unicode_block'
  autoload :NGram, 'langusta/n_gram'
  autoload :DetectorFactory, 'langusta/detector_factory'
  autoload :Detector, 'langusta/detector'
  autoload :TagExtractor, 'langusta/tag_extractor'
  autoload :Command, 'langusta/command'
  autoload :LanguageDetectionFacade, 'langusta/language_detection_facade'

  ABSOLUTE_PATH = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  PROFILES_PATH = File.join(ABSOLUTE_PATH, 'profiles')
  UPPERCASE_BIN = File.join(ABSOLUTE_PATH, 'data/uppercase.bin')
  MESSAGES_PROPERTIES = File.join(ABSOLUTE_PATH, 'data/messages.properties')

  class DuplicateProfilesError < StandardError; end
  class NoProfilesLoadedError < StandardError; end
  class NoFeaturesInTextError < StandardError; end
end

