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
      puts "do you want to proceed with the commit? y[N]"
      answer = gets.chomp
      raise unless answer == "y"
    end
  end

  def to_not(comparable_fact)
    if @guess != comparable_fact
      puts "OK"
    else
      puts "WARN. because: #{@guess}"
      puts "do you want to proceed with the commit? y[N]"
      answer = gets.chomp
      raise unless answer == "y"
    end
  end
end
