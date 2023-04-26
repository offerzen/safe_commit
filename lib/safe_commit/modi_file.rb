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
        generate_rspec_test_files
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

    private

    def generate_rspec_test_files
      differentiator = "spec"
      file_list = modified_files.grep_v(/spec/)

      output, = Open3.capture2(%(echo "#{file_list.join("\n")}" | sed 's/\\.rb/\\_#{differentiator}\\.#{file_extension.gsub(".", "")}/g'))
      output_lines = output.split("\n")

      process_output_lines(output_lines)
    end

    def process_output_lines(output_lines)
      arr = []
      if output_lines.any? { |line| line.match?(%r{lib/}) }
        arr << output_lines.grep(%r{lib/}).map { |b| b.gsub("lib/", "spec/lib/") }
      elsif output_lines.any? { |line| line.match?(%r{app/}) }
        arr << output_lines.grep(%r{app/}).map { |b| b.gsub("app/", "spec/") }
      end
      arr.flatten
    end
  end
end
