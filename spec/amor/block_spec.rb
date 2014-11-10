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
  end
end