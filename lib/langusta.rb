$: << File.expand_path(File.dirname(__FILE__))

require 'rubygems'
require 'bundler'
Bundler.require

require 'optparse'
require 'iconv'

module Langusta
  VERSION = '0.1.1'

  autoload :Guard, 'langusta/guard'
  autoload :Inspector, 'langusta/inspector'
  autoload :RegexHelper, 'langusta/regex_helper'
  autoload :Codepoints, 'langusta/codepoints'
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

  class Error < StandardError; end
  class DuplicateProfilesError < Error; end
  class NoProfilesLoadedError < Error; end
  class NoFeaturesInTextError < Error; end

  def self.utf82cp(utf8_string)
    Iconv.conv('ucs-2be', 'utf-8', utf8_string).unpack('n*')
  end

  def self.cp2utf8(cp_array)
    Iconv.conv('utf-8', 'ucs-2be', cp_array.pack('n*'))
  end
end

