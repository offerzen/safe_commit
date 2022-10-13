# frozen_string_literal: true

class SafeCommit::ModiFile
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
      `git status | egrep 'modified.*\.rb' | awk '{print $2}'`.split("\n")
    else
      puts "#{file_extension} extension not supported"
    end
  end

  def expected_test_files
    case test_engine
    when "rspec"
      differentiator = "spec"
      `echo #{ModiFile.instance.modified_files.join("\n")} | sed 's/\.rb/\_#{differentiator}\.#{@file_extension.gsub(
        ".", ""
      )}/g'`&.gsub("app", "spec")&.split("\n")
    else
      []
    end
  end

  def test_files
    available_files = []
    expected_test_files.each do |file|
      result = `sh -c 'if [ ! -f #{file} ]; then
                echo "File not found!"
              fi'
      `
      available_files << file if result.empty?
    end
    available_files
  end
end
