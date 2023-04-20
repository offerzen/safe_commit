# frozen_string_literal: true

require "singleton"
require "colorize"
require "open3"

require_relative "safe_commit/version"
require_relative "safe_commit/assertion"
require_relative "safe_commit/modi_file"

module SafeCommit
  class Error < StandardError; end

  def expect(guess)
    Assertion.instance.guess = guess
    Assertion.instance
  end

  # Testing DSL

  def test_engine(setting)
    ModiFile.instance.test_engine = setting
  end

  def tests(options = { safety: true, verbose: false })
    puts "Running tests...".colorize(:green)

    rspec_output = run_rspec(test_files(options))
    if /errors occurred/ =~ rspec_output
      print(rspec_output.colorize(:red))
      "Error running tests, skipping..."
    else
      puts rspec_output if options[:verbose]
      extract_failed_tests_count(rspec_output)
    end
  end

  def pass
    "0 failures"
  end

  # git DSL

  def file_extension_to_examine(setting)
    ModiFile.instance.file_extension = setting
  end

  def modified_files
    ModiFile.instance.modified_files
  end

  def test_files(options = { safety: true })
    case options[:safety]
    when true
      ModiFile.instance.test_files
    else
      ModiFile.instance.expected_test_files
    end
  end

  def branch
    `git branch --show-current`.chomp
  end

  def trunk_branch(setting)
    ModiFile.instance.protected_branch = setting
  end

  def be_trunk
    ModiFile.instance.protected_branch.to_s
  end

  # linting DSL

  def linting
    output, = Open3.capture2("rubocop  #{ModiFile.instance.modified_files.join(" ")} | tail -n 1 | awk -F, '{print $2}'")
    output.chomp
  end

  def be_acceptable_enough(threshold = 0)
    "below the threshold of #{threshold} offenses"
  end

  def be_acceptable
    " no offenses detected"
  end

  private

  def run_rspec(test_filenames)
    rspec_command = "./bin/rspec #{test_filenames.join(" ")} --format documentation"
    output, = Open3.capture2(rspec_command)
    output
  end

  def extract_failed_tests_count(rspec_output)
    rspec_output.split("\n")[-3].split(", ")[1]
  end
end
