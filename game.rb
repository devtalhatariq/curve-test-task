require_relative 'app/simulator/toy'
require_relative 'app/validations/table'

puts "==> Toy Robot Simulator <=="
puts "Enter instruction: (eg:\'PLACE X,Y,NORTH|SOUTH|EAST|WEST\', MOVE, LEFT, RIGHT, REPORT or EXIT)"

@table = ::Validations::Table.new
@toy = ::Simulator::Toy.new(@table)

instruction = STDIN.gets
instruction.strip!

until instruction.downcase == "exit" do
  begin
    puts @toy.perform(instruction)
  rescue Exception => e
    puts e.message
  end

  instruction = STDIN.gets
  instruction.strip!
end
