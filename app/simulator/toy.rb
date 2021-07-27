require_relative '../instructions/direction'
require_relative '../instructions/command'
require_relative '../validations/position'
require_relative '../controllers/command'

module Simulator
  class Toy
    attr_reader :position, :direction, :table

    def initialize(table)
      raise TypeError, 'Invalid Table' if table.nil?

      @table = table
    end

    def perform(instruction)
      return if instruction.strip.empty?

      command_action = ::Controllers::Command.execute(instruction)
      send(command_action[:method_name], *command_action[:params])
    end

    def place(x, y, direction)
      raise TypeError, 'Invalid coordinates' unless x.is_a? Integer and y.is_a? Integer
      raise TypeError, 'Invalid direction' unless ::Instructions::Direction::VALID_DIRECTIONS.include?(direction)

      if ::Validations::Position.valid?(x, y, self.table)
        @position = { x: x, y: y } and @direction = direction
        true
      else
        false
      end
    end

    def move
      return false if @position.nil?

      movement = ::Instructions::Direction.step_in_direction(@direction)

      if ::Validations::Position.valid?(@position[:x] + movement[:x], @position[:y] + movement[:y], self.table)
        @position = { x: @position[:x] + movement[:x], y: @position[:y] + movement[:y] } and return true
      end

      false
    end

    def rotate_left
      return false if @direction.nil?

      rotate_index = ::Instructions::Direction::VALID_DIRECTIONS.index(@direction)
      @direction = ::Instructions::Direction::VALID_DIRECTIONS.rotate(-1)[rotate_index]
    end

    def rotate_right
      return false if @direction.nil?

      rotate_index = ::Instructions::Direction::VALID_DIRECTIONS.index(@direction)
      @direction = ::Instructions::Direction::VALID_DIRECTIONS.rotate()[rotate_index]
    end

    def report
      return "Not on grid" if @position.nil? or @direction.nil?

      "#{@position[:x]},#{@position[:y]},#{@direction.to_s.upcase}"
    end
  end
end
