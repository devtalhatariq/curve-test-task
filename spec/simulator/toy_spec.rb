require_relative '../spec_helper'

describe ::Simulator::Toy do
  let(:grid) { ::Validations::Table.new }
  let(:toy) { ::Simulator::Toy.new(grid) }

  describe ' Commands' do
    before do
      toy.perform("PLACE 0,0,NORTH")
      toy.perform("MOVE")
      toy.perform("RIGHT")
      toy.perform("MOVE")
    end

    context 'when correct commands' do
      it {expect(toy.report).to eq("1,1,EAST")}
    end

    context 'when incorrect commands' do
      it {expect { toy.perform("PLACE12NORTH") }.to raise_error(ArgumentError)}
      it {expect { toy.perform("LEFFT") }.to raise_error(ArgumentError)}
      it {expect { toy.perform("RIGHTT") }.to raise_error(ArgumentError)}
    end
  end

  describe 'Params' do
    context 'when correct params' do
      it {expect(toy.place(0, 1, :north)).to eq(true)}
      it {expect(toy.place(2, 2, :south)).to eq(true)}
    end

    context 'when wrong params' do
      it {expect(toy.place(6, 6, :west)).to eq(false)}
      it {expect(toy.place(-1, 5, :east)).to eq(false)}
    end
  end

  describe ' Exceptions' do
    context 'returns correct exceptions' do
      it {expect { toy.place(nil, nil, :east) }.to raise_error(TypeError)}
      it {expect { toy.place(1, 'abc', nil) }.to raise_error(TypeError)}
      it {expect { toy.place(1, 0, :northeast) }.to raise_error(TypeError)}
    end
  end

  describe 'Movement' do
    context 'move correctly' do
      before do
        toy.place(0, 0, :north)
      end
      it {expect(toy.move).to eq(true)}
    end

    context 'correct positions' do
      before do
        toy.place(0, 0, :north)
        toy.move
      end
      it {expect(toy.position[:x]).to eq(0)}
      it {expect(toy.position[:y]).to eq(1)}
    end
  end

  describe 'Rotation' do
    before do
      toy.place(0, 0, :north)
    end

    context 'left rotation' do
      it 'return back to north' do
        expect(toy.rotate_left).to eq(:west)
        expect(toy.rotate_left).to eq(:south)
        expect(toy.rotate_left).to eq(:east)
        expect(toy.rotate_left).to eq(:north)
      end
    end

    context ' right rotation' do
      it 'return back to north from right' do
        expect(toy.rotate_right).to eq(:east)
        expect(toy.rotate_right).to eq(:south)
        expect(toy.rotate_right).to eq(:west)
        expect(toy.rotate_right).to eq(:north)
      end
    end
  end

  describe 'Report' do
    before do
      toy.place(5, 5, :east)
    end

    context 'report correct position and direction' do
      it {expect(toy.report).to eq("5,5,EAST")}
    end
  end
end
