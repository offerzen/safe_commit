# frozen_string_literal: true

module SafeCommit
  class ModiFile
    include Singleton

    attr_accessor :file_extension, :test_engine, :protected_branch

    def initialize
      @file_extension = ".rb"
      @test_engine = "rspec"
      @protected_branch = "master"
    end

    def modified_files
      case file_extension
      when ".rb"
        output, = Open3.capture2("git status | sed 's/new file/newfile/g' | egrep '(modified|newfile).*\\.rb' | awk '{print $2}'")
        output.split("\n").uniq
      else
        abort("❗️ #{file_extension} extension not supported".colorize(:red))
      end
    end

    def expected_test_files
      case test_engine
      when "rspec"
        differentiator = "spec"
        file_list = modified_files.join("\n")
        output, = Open3.capture2(%(echo "#{file_list}" | sed 's/\\.rb/\\_#{differentiator}\\.#{file_extension.gsub(
          ".", ""
        )}/g'))
        output.gsub("app", "spec").split("\n")
      else
        abort("❗️ unsupported test engine: #{test_engine}".colorize(:red))
      end
    end

    def test_files
      available_files = []
      expected_test_files.each do |file|
        output, = Open3.capture2("sh -c 'if [ ! -f #{file} ]; then echo \"File not found!\"; fi'")
        available_files << file if output.empty?
      end
      available_files
    end
  end
end
