require 'amor/constraint'

module Amor
  describe Constraint do
    describe '.new' do
      before(:each) do
        @lhs = Expression.new(4)
        @rhs = Expression.new(8)
      end

      it 'returns a Constraint with the given left hand side' do
        expect(Constraint.new(@lhs, :lesser_equal, @rhs).lhs).to eql(@lhs)
      end

      it 'returns a Constraint with the given right hand side' do
        expect(Constraint.new(@lhs, :lesser_equal, @rhs).rhs).to eql(@rhs)
      end

      it 'returns a Constraint with the given relation' do
        expect(Constraint.new(@lhs, :lesser_equal, @rhs).relation).to eq(:lesser_equal)
      end
    end
  end
end
