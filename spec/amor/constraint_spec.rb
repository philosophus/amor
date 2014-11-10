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

    describe '#lp_string' do
      it 'returns a LP format ready version of the constraint' do
        model = Model.new
        v1 = model.x(1)
        v2 = model.x(2)
        v3 = model.x(3)
        constraint = model.st(Constraint.new(Expression.new([[3, v1], [-2.0, v2], [2, :constant], [2.5, v3]]), :lesser_equal, Expression.new(5)))
        expect(constraint.lp_string).to eq('c1: 3 x1 - 2.0 x2 + 2.5 x3 <= 3')
      end
    end

    describe '#lp_name' do
      it 'returns the indexed contraint name' do
        model = Model.new
        v1 = model.x(1)
        v2 = model.x(2)
        v3 = model.x(3)
        constraint = model.st(Constraint.new(Expression.new([[3, v1], [-2.0, v2], [2, :constant], [2.5, v3]]), :lesser_equal, Expression.new(5)))
        expect(constraint.lp_name).to eq("c1")
      end
    end

  end
end
