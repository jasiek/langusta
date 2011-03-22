$: << File.expand_path(File.dirname(__FILE__))

module Langusta
  VERSION = '0.0.1'

  autoload :Language, 'langusta/language'
  autoload :Detector, 'langusta/detector'
end
