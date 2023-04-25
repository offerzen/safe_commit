# frozen_string_literal: true
require "spec_helper"


RSpec.describe SafeCommit do
  it "has a version number" do
    expect(SafeCommit::VERSION).to_not be_nil
  end

  describe "#expect" do
    it "returns an instance of Assertion with the guess set" do
      guess = "some guess"
      expect_result = described_class.expect(guess)
      expect(expect_result).to be_instance_of(SafeCommit::Assertion)
      expect(expect_result.guess).to eq(guess)
    end
  end

  describe "#test_engine" do
    it "sets the test engine for ModiFile instance" do
      test_engine_setting = "rspec"
      test_engine(test_engine_setting)
      expect(ModiFile.instance.test_engine).to eq(test_engine_setting)
    end
  end

  describe "#tests" do
    let(:options) { { safety: true, verbose: false } }

    xit "returns '0 failures' when no errors occur during testing" do
      allow(self).to receive(:extract_failed_tests_count).and_return("0 failures")
      expect(tests(options)).to eq("0 failures")
    end

    xit "returns 'Error running tests, skipping...' when errors occur during testing" do
      allow(self).to receive(:run_rspec).and_return("errors occurred")
      expect(tests(options)).to eq("Error running tests, skipping...")
    end
  end

  describe "#file_extension_to_examine" do
    it "sets the file extension for ModiFile instance" do
      file_extension = ".rb"
      file_extension_to_examine(file_extension)
      expect(ModiFile.instance.file_extension).to eq(file_extension)
    end
  end

  describe "#modified_files" do
    it "returns modified_files from ModiFile instance" do
      modified_files_array = %w[file1 file2]
      allow(ModiFile.instance).to receive(:modified_files).and_return(modified_files_array)
      expect(modified_files).to eq(modified_files_array)
    end
  end

  describe "#test_files" do
    let(:options) { { safety: true } }
    let(:test_files_array) { %w[file1 file2] }

    it "returns test_files from ModiFile instance when safety option is true" do
      allow(ModiFile.instance).to receive(:test_files).and_return(test_files_array)
      expect(test_files(options)).to eq(test_files_array)
    end

    it "returns expected_test_files from ModiFile instance when safety option is false" do
      options[:safety] = false
      allow(ModiFile.instance).to receive(:expected_test_files).and_return(test_files_array)
      expect(test_files(options)).to eq(test_files_array)
    end
  end

  describe "#branch" do
    it "returns the current branch name" do
      branch_name = "main"
      allow(self).to receive(:`).with("git branch --show-current").and_return("#{branch_name}\n")
      expect(branch).to eq(branch_name)
    end
  end

  describe "#trunk_branch" do
    it "sets the protected branch for ModiFile instance" do
      protected_branch = "main"
      trunk_branch(protected_branch)
      expect(ModiFile.instance.protected_branch).to eq(protected_branch)
    end
  end

  describe "#be_trunk" do
    it "returns the protected branch from ModiFile instance as a string" do
      protected_branch = "main"
      allow(ModiFile.instance).to receive(:protected_branch).and_return(protected_branch)
      expect(be_trunk).to eq(protected_branch)
    end
  end
    
  describe "#linting" do
    it "returns the rubocop linting output" do
      rubocop_output = "no offenses detected"
      allow(Open3).to receive(:capture2).and_return([rubocop_output])
      expect(linting).to eq(rubocop_output)
    end
  end
    
  describe "#be_acceptable_enough" do
    it "returns a string with the threshold of offenses" do
      threshold = 5
      expect(be_acceptable_enough(threshold)).to eq("below the threshold of #{threshold} offenses")
    end
  end
    
  describe "#no_presence_of" do
    let(:pattern) { "binding.pry" }
    let(:message) { "There should be no bindings" }

    context "when pattern is found in the diff" do
      it "outputs the message and calls Assertion.instance.error" do
        allow(Open3).to receive(:capture2).and_return(["1:#{pattern}\n"])
        expect(Assertion.instance).to receive(:error).with(message)
        no_presence_of(pattern, message)
      end
    end
    
    context "when pattern is not found in the diff" do
      it "does not call Assertion.instance.error" do
        allow(Open3).to receive(:capture2).and_return([""])
        expect(Assertion.instance).not_to receive(:error)
        no_presence_of(pattern, message)
      end
    end
  end

  describe "#suggest_refactors" do
    let(:modified_file) { "some_file.rb" }
    let(:file_content) { "def some_method; end" }
    let(:openai_api_key) { "test_key" }
    let(:response) { double("response", dig: "suggestion") }
    
    before do
      allow(ENV).to receive(:fetch).with("SAFE_COMMIT_OPENAI_API_KEY").and_return(openai_api_key)
      allow(File).to receive(:read).with(modified_file).and_return(file_content)
      allow(self).to receive(:modified_files).and_return([modified_file])
      allow(Interaction).to receive(:confirm).and_return(true)
      allow(OpenAI::Client).to receive(:new).and_return(double("client", chat: response))
    end
    
    it "returns suggestions from ChatGPT API" do
      expect(suggest_refactors).to be_nil
    end
  end
end
