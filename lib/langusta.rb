$: << File.expand_path(File.dirname(__FILE__))

require 'rubygems'

require 'optparse'
require 'yajl'

if RUBY_VERSION < "1.9"
  require 'iconv'
  require 'oniguruma'
end

require 'langusta/version'

module Langusta
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

  UTF82CP_SELECTOR = RUBY_VERSION < "1.9" ? :utf82cp_18 : :utf82cp_19
  CP2UTF8_SELECTOR = RUBY_VERSION < "1.9" ? :cp2utf8_18 : :cp2utf8_19

  def self.utf82cp(utf8_string)
    send(UTF82CP_SELECTOR, utf8_string)
  end

  def self.utf82cp_18(utf8_string)
    Iconv.conv('ucs-2be', 'utf-8', utf8_string).unpack('n*')
  end

  def self.utf82cp_19(utf8_string)
    utf8_string.encode('ucs-2be').unpack('n*')
  end

  def self.cp2utf8(cp_array)
    send(CP2UTF8_SELECTOR, cp_array)
  end

  def self.cp2utf8_18(cp_array)
    Iconv.conv('utf-8', 'ucs-2be', cp_array.pack('n*'))
  end

  def self.cp2utf8_19(cp_array)
    cp_array.pack('n*').force_encoding('ucs-2be').encode('utf-8')
  end
end

