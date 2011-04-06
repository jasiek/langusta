require 'test/helper'

class CommandTest < Test::Unit::TestCase
  def test_help
    Command.run([])
  end

  def test_optparse_detect_lang
    Command.any_instance.expects(:detect_lang).with('profiles', ['abc.txt', 'def.txt'], 0.5)
    Command.run(['--detectlang', '-d', 'profiles', '-a', '0.5', 'abc.txt', 'def.txt'])

    Command.any_instance.expects(:detect_lang).with('profiles', ['abc.txt', 'def.txt'])
    Command.run(['--detectlang', '-d', 'profiles', 'abc.txt', 'def.txt'])
  end

  def test_optparse_batch_test
    Command.any_instance.expects(:batch_test).with('profiles', ['abc.txt', 'def.txt'], 0.5)
    Command.run(['--batchtest', '-d', 'profiles', '-a', '0.5', 'abc.txt', 'def.txt'])

    Command.any_instance.expects(:batch_test).with('profiles', ['abc.txt', 'def.txt'])
    Command.run(['--batchtest', '-d', 'profiles', 'abc.txt', 'def.txt'])
  end

  def test_detect_lang
    cmd = Command.new
    cmd.detect_lang('profiles', ['test/test_data/polski.txt'])
  end
end
