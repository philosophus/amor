require 'amor/block'

module Amor
  describe Block do
    describe '#add_contraint' do
      it 'adds a constraint' do
        block = Block.new
        constraint = double('Constraint')
        block.add_constraint(constraint)
        expect(block.constraints[0]).to eq(constraint)
      end
    end

    describe '#dec_string' do
      it 'returns a representation of the block for the .dec file format' do
        constraint1 = double('Constraint')
        allow(constraint1).to receive(:lp_name).and_return('c1')
        constraint2 = double('Constraint')
        allow(constraint2).to receive(:lp_name).and_return('c2')
        block = Block.new
        block.add_constraint(constraint1)
        block.add_constraint(constraint2)
        expect(block.dec_string(1)).to eq("BLOCK 1\nc1\nc2")
      end
    end
  end
end