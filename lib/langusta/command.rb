module Langusta
  class Command
    def self.run(argv)
      options = {}
      opts = OptionParser.new do |opts|
        opts.on("--detectlang", "Detect the language from the given text") do |d|
          options[:operation] = :detectlang if d
        end

        opts.on("--batchtest", "Batch test of language detection") do |b|
          options[:operation] = :batchtest if b
        end

        opts.on("-d [profile directory]") do |pd|
          options[:profile_directory] = pd
        end

        opts.on("-a [alpha]", Float) do |alpha|
          options[:alpha] = alpha
        end
      end.parse!(argv)

      arguments = [options[:profile_directory]] + [argv]
      arguments << options[:alpha] if options[:alpha]

      case options[:operation]
      when :detectlang
        self.new.send(:detect_lang, *arguments)
      when :batchtest
        self.new.send(:batch_test, *arguments)
      else
        $stderr.puts <<EOF
Usage:

  langusta --detectlang -d [profile directory] -a [alpha] [test file(s)]
  langusta --batchtest -d [profile directory] -a [alpha] [test file(s)]
EOF
      end
    end

    def detect_lang(profile_directory, test_files, alpha=nil)
      @profiles = load_profiles(profile_directory)
    end

    def batch_test(profile_directory, test_files, alpha=nil)
    end

    private
    def load_profiles(directory)
      @profiles = Dir[File.join(directory, '/*')].map do |filename|
        LangProfile.load_from_file(filename)
      end
    end
  end
end
