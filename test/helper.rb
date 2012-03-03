require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :test)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'test/unit'
require 'mocha'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'langusta'

class Test::Unit::TestCase
  include Langusta

  def str2cp(ascii_string)
    Iconv.conv('ucs-2be', 'ascii', ascii_string).unpack('n*')
  end

  def utf82cp(utf8_string)
    Langusta.utf82cp(utf8_string)
  end
end

$debug = true
