# frozen_string_literal: true

module Interaction
  module_function

  def confirm(message)
    print message.colorize(:yellow)

    response = $stdin.gets.chomp.downcase
    case response
    when "y"
      puts
      true
    when "x"
      puts "skipping..."
      nil
    else
      exit(1)
    end
  end
end
