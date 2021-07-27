require_relative '../instructions/command'
require_relative 'movement'

module Controllers
  class Command
    
    def self.execute(instruction)
      argument_list = instruction.split(/\s+/)
      command = argument_list.first.to_s.downcase.to_sym
      arguments = argument_list.last

      raise ArgumentError, 'Invalid command' unless ::Instructions::Command::VALID_COMMANDS.include?(command)

      ::Controllers::Movement.new.call(command, arguments)
    end
  end
end
