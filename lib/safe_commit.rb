# frozen_string_literal: true

require "singleton"

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
    puts "running tests..."
    a = `./bin/rspec #{test_files(options).join(" ")} --format documentation`
    puts a if options[:verbose]
    a.split("\n")[-3].split(", ")[1]
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
    `git branch --show-current`
  end

  def trunk_branch(setting)
    ModiFile.instance.protected_branch = setting
  end

  def be_trunk
    "#{ModiFile.instance.protected_branch}\n"
  end

  # linting DSL

  def linting
    `echo #{ModiFile.instance.modified_files.join("\n")} | xargs rubocop | tail -n 1 | awk -F, '{print $2}'`
  end

  def be_acceptable_enough(threshold = 0)
    " #{threshold} offenses detected\n"
  end

  def be_acceptable
    be_acceptable_enough(0)
  end
end
