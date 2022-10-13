# frozen_string_literal: true

class SafeCommit::Assertion
  include Singleton

  attr_accessor :guess

  def initialize; end

  def to(comparable_fact)
    if @guess == comparable_fact
      puts "OK"
    else
      puts "Exiting. because: #{@guess}"
      exit!
    end
  end

  def to_not(comparable_fact)
    if @guess != comparable_fact
      puts "OK"
    else
      puts "Exiting. because: #{@guess}"
      exit!
      # raise "halting commit" unless answer == "y"
    end
  end
end
