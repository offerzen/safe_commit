# frozen_string_literal: true

module SafeCommit
  class Assertion
    include Singleton

    attr_accessor :guess

    def to(comparable_fact)
      if @guess == comparable_fact
        message = "✅ \t#{@guess} is equal to #{comparable_fact}. Continuing...\n"
        print message.colorize(:green)
      else
        message = "⚠️ \t#{@guess} is not #{comparable_fact}.\t Continue with commit? (y/n) "
        confirm(message)
      end
    end

    def to_not(comparable_fact)
      if @guess == comparable_fact
        message = "⚠️ \t#{@guess} is equal to #{comparable_fact}. \t Continue with commit? (y/n) "
        confirm(message)
      else
        message = "✅ \t#{@guess} is not #{comparable_fact}. Continuing...\n"
        print message.colorize(:green)
      end
    end

    private

    def confirm(message)
      print message.colorize(:yellow)

      response = $stdin.gets.chomp.downcase
      if response == "y"
        puts
        true
      else
        exit(1)
      end
    end
  end
end
