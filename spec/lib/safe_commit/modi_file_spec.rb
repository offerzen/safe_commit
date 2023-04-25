# frozen_string_literal: true

# spec/safe_commit/modi_file_spec.rb
require "safe_commit/modi_file"

RSpec.describe SafeCommit::ModiFile do
  subject { described_class.instance }

  describe "#modified_files" do
    context "when file_extension is .rb" do
      it "returns an array of modified .rb files" do
        allow(Open3).to receive(:capture2).and_return(["file1.rb\nfile2.rb\n", ""])
        expect(subject.modified_files).to eq(["file1.rb", "file2.rb"])
      end
    end

    context "when file_extension is not supported" do
      it "aborts with an error message" do
        subject.file_extension = ".unsupported"
        expect { subject.modified_files }.to raise_error(SystemExit).and output(/❗️/).to_stderr
      end
    end
  end

  describe "#expected_test_files" do
    context "when test_engine is rspec" do
      it "returns an array of corresponding test files" do
        allow(subject).to receive(:modified_files).and_return(["app/models/user.rb"])
        allow(Open3).to receive(:capture2).and_return(["spec/models/user_spec.rb\n", ""])
        expect(subject.expected_test_files).to eq(["spec/models/user_spec.rb"])
      end
    end

    context "when test_engine is not supported" do
      it "returns an empty array" do
        subject.test_engine = "unsupported"
        # expect(subject.expected_test_files).to eq([])
        expect { subject.expected_test_files }.to raise_error(SystemExit).and output(/❗️/).to_stderr
      end
    end
  end

  describe "#test_files" do
    context "when test files exist" do
      it "returns an array of available test files" do
        allow(subject).to receive(:expected_test_files).and_return(["spec/models/user_spec.rb"])
        allow(Open3).to receive(:capture2).and_return(["", ""])
        expect(subject.test_files).to eq(["spec/models/user_spec.rb"])
      end
    end

    context "when test files do not exist" do
      it "returns an empty array" do
        allow(subject).to receive(:expected_test_files).and_return(["spec/models/non_existent_spec.rb"])
        allow(Open3).to receive(:capture2).and_return(["File not found!", ""])
        expect(subject.test_files).to eq([])
      end
    end
  end
end
