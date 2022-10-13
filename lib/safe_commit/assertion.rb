# frozen_string_literal: true

class SafeCommit::Assertion
  include Singleton

  attr_accessor :guess

  def initialize; end

  def to(comparable_fact)
    if @guess == comparable_fact
      puts "OK"
    else
      puts "WARN. because: #{@guess}"
    end
  end

  def to_not(comparable_fact)
    if @guess != comparable_fact
      puts "OK"
    else
      puts "WARN. because: #{@guess}"
    end
  end
end
