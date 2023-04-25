# frozen_string_literal: true

module SafeCommit
  class Assertion
    include Singleton

    attr_accessor :guess

    def to(comparable_fact)
      if guess == comparable_fact
        message = "✅ \t#{guess} is equal to #{comparable_fact}. Continuing...\n"
        print message.colorize(:green)
      else
        message = "⚠️ \t#{guess} is not #{comparable_fact}.\t Continue with commit? (y/n) "
        Interaction.confirm(message)
      end
    end

    def to_not(comparable_fact)
      if guess == comparable_fact
        message = "⚠️ \t#{guess} is equal to #{comparable_fact}. \t Continue with commit? (y/n) "
        Interaction.confirm(message)
      else
        message = "✅ \t#{guess} is not #{comparable_fact}. Continuing...\n"
        print message.colorize(:green)
      end
    end

    def error(message = nil)
      message = if message.nil?
                  "⚠️ \tERROR\t Continue with commit? (y/n) "
                else
                  "⚠️ \t #{message} detected.\t Continue with commit? (y/n) "
                end
      Interaction.confirm(message)
    end
  end
end
