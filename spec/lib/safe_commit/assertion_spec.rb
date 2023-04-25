# frozen_string_literal: true

require "safe_commit/assertion"

RSpec.describe SafeCommit::Assertion do
  subject { described_class.instance }

  describe "#to" do
    context "when guess is equal to comparable_fact" do
      it "prints a success message and continues" do
        subject.guess = 5
        expect { subject.to(5) }.to output(/✅/).to_stdout
      end
    end

    context "when guess is not equal to comparable_fact" do
      it "prints a warning message and asks for confirmation" do
        subject.guess = 5
        allow($stdin).to receive(:gets).and_return("n")
        expect { subject.to(10) }.to output(/⚠️/).to_stdout.and raise_error(SystemExit)
      end
    end
  end

  describe "#to_not" do
    context "when guess is not equal to comparable_fact" do
      it "prints a success message and continues" do
        subject.guess = 5
        expect { subject.to_not(10) }.to output(/✅/).to_stdout
      end
    end

    context "when guess is equal to comparable_fact" do
      it "prints a warning message and asks for confirmation" do
        subject.guess = 5
        allow($stdin).to receive(:gets).and_return("n")
        expect { subject.to_not(5) }.to output(/⚠️/).to_stdout.and raise_error(SystemExit)
      end
    end
  end
end
