# -*- coding: utf-8 -*-
require 'test/helper'

class LanguageDetectionFacadeTest < Test::Unit::TestCase
  def test_initialize_and_detect
    facade = LanguageDetectionFacade.new
    assert_equal("pl", facade.detect(Langusta.utf82cp("Ich dalekopis fałszuje, gdy próby XQV nie wytrzymuje")))
  end
end
