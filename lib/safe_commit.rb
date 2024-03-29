# frozen_string_literal: true

require "singleton"
require "colorize"
require "open3"
require "dotenv/load"
require "openai"

require_relative "safe_commit/version"
require_relative "safe_commit/assertion"
require_relative "safe_commit/modi_file"
require_relative "safe_commit/interaction"

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
    if test_files(options).empty?
      puts "No available tests to run on changed files"
      return pass
    end

    rspec_output = run_rspec(test_files(options))
    if /errors? occurred/ =~ rspec_output
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
    output, = Open3.capture2("rubocop #{ModiFile.instance.modified_files.join(" ")} | tail -n 1 | awk -F, '{print $2}'")
    output.chomp
  end

  def be_acceptable_enough(threshold = 0)
    "below the threshold of #{threshold} offenses"
  end

  def be_acceptable
    " no offenses detected"
  end

  # custom gotchas
  def no_presence_of(pattern, message = nil)
    puts "checking for presence of #{pattern}...".colorize(:green)
    stdout, = Open3.capture2("git diff --cached | grep -ne #{pattern}")
    return if stdout.empty?

    puts stdout
    Assertion.instance.error(message)
  end

  def suggest_refactors
    modified_files.each do |modified_file|
      message = "💡\t want ChatGPT advice on refactoring #{modified_file}? (y/x)".colorize(:green)
      proceed = Interaction.confirm(message)
      next unless proceed

      f = File.read(modified_file.to_s)
      exit(1) if ENV.fetch("SAFE_COMMIT_OPENAI_API_KEY").nil? || f.nil?

      puts get_suggestions(f)
    end
    nil
  end

  private

  def run_rspec(test_filenames)
    rspec_command = "./bin/rspec #{test_filenames.join(" ")} --format progress --profile 0"
    puts "\t#{rspec_command}".colorize(:green)
    output, = Open3.capture2(rspec_command)
    output
  end

  def extract_failed_tests_count(rspec_output)
    test_results = rspec_output.split("\n").select { |element| element.match(/\d+ examples?, \d+ failures?(, \d+ pending)?/) }

    puts "\n\t#{test_results}".colorize(:yellow)
    return "ERROR tests fail" if test_results[0].nil?

    test_results[0].match(/(?<fails>\d+ failures?)/)[:fails]
  end

  def chat_gpt_payload(filename)
    {
      model: "gpt-4",
      messages: [
        {
          role: "system",
          content: "You are an ruby software developer expert tasked with refactoring ruby code to follow best practices and optimise readability."
        },
        { role: "assistant", content: "Sure, I'd be happy to help! Can you provide me with the code that needs to be refactored?" },
        { role: "user", content: filename.to_s }
      ],
      temperature: 0.7
    }
  end

  def get_suggestions(filename)
    client = OpenAI::Client.new(access_token: ENV.fetch("SAFE_COMMIT_OPENAI_API_KEY"))

    response = client.chat(parameters: chat_gpt_payload(filename))
    response.dig("choices", 0, "message", "content")
  end
end
