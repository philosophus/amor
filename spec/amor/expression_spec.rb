require 'amor/expression'

module Amor
  describe Expression do
    before(:each) do
      @variable = double('Variable')
      @expression = Expression.new([[2, @variable]])
    end

    describe '.new' do
      context 'when used with another Expression' do
        before(:each) do
          @other_variable = double('Variable')
          @other_expression = Expression.new([[3.0, @other_variable]])
        end

        it 'Copys the Expression' do
          expect(Expression.new(@other_expression).factors).to eq(@other_expression.factors)
        end
      end

      context 'when used with an Array of factors' do
        before(:each) do
          @factors = [[3.0, double('Variable')]]
        end

        it 'Creates an Expression with the given factors' do
          expect(Expression.new(@factors).factors).to eq(@factors)
        end
      end

      context 'when used with a Variable' do
        before(:each) do
          @variable = Variable.new(double('Model'),1)
        end

        it 'Creates an Expression with the given variable as factor with scalar 1' do
          expect(Expression.new(@variable).factors).to eq([[1, @variable]])
        end
      end

      [-3, -3.0].each do |number|
        context "when used with a #{number.class}" do
          it 'Creates an Expression with the given number as a constant factor' do
            expect(Expression.new(number).factors).to eq([[number, :constant]])
          end
        end
      end

    end

    describe '#+' do
      context 'when used with another Expression' do
        before(:each) do
          @other_variable = double('Other Variable')
          @other_expression = Expression.new([[3.0, @other_variable]])
        end

        it 'returns an Expression' do
          expect(@expression + @other_expression).to be_a(Expression)
        end

        it 'returns an Expression with the combined factors of both Expressions' do
          expect((@expression + @other_expression).factors).to eq([[2, @variable], [3.0, @other_variable]])
        end
      end

      context 'when used with a variable' do
        before(:each) do
          @other_variable = Variable.new(double('Model'),1)
        end

        it 'returns an Expression' do
          expect(@expression + @other_variable).to be_a(Expression)
        end

        it 'returns an Expression with the factor of the variable set to 1' do
          expect((@expression + @other_variable).factors).to eq([[2, @variable], [1, @other_variable]])
        end
      end

      [4, 4.0].each do |number|
        context "when used with a #{number.class}" do
          it 'returns an Expression' do
            expect(@expression + number).to be_a(Expression)
          end

          it 'returns an Expression with the the last factor set to the corresponding constant' do
            expect((@expression + number).factors).to eq([[2, @variable], [number, :constant]])
          end
        end
      end
    end

    describe '#-' do
      context 'when used with another Expression' do
        before(:each) do
          @other_variable = double('Other Variable')
          @other_expression = Expression.new([[3.0, @other_variable]])
        end

        it 'returns an Expression' do
          expect(@expression - @other_expression).to be_a(Expression)
        end

        it 'returns an Expression with the combined factors of the first Expression and the negative second Expression' do
          expect((@expression - @other_expression).factors).to eq([[2, @variable], [-3.0, @other_variable]])
        end
      end

      context 'when used with a variable' do
        before(:each) do
          @other_variable = Variable.new(double('Model'),1)
        end

        it 'returns an Expression' do
          expect(@expression - @other_variable).to be_a(Expression)
        end

        it 'returns an Expression with the factor of the variable set to -1' do
          expect((@expression - @other_variable).factors).to eq([[2, @variable], [-1, @other_variable]])
        end
      end

      [4, 4.0].each do |number|
        context "when used with a #{number.class}" do
          it 'returns an Expression' do
            expect(@expression - number).to be_a(Expression)
          end

          it 'returns an Expression with the the last factor set to the corresponding negative constant' do
            expect((@expression - number).factors).to eq([[2, @variable], [-number, :constant]])
          end
        end
      end
    end

    describe '#-@' do
      it 'returns an Expression' do
        expect(-@expression).to be_a(Expression)
      end

      it 'returns an Expression with the negative factors' do
        expect((-@expression).factors).to eq([[-2, @variable]])
      end
    end

    describe '#<=' do
      context 'when used with another Expression' do
        before(:each) do
          @other_expression = Expression.new(5.0)
        end

        it 'returns a Constraint' do
          expect(@expression <= @other_expression).to be_a(Constraint)
        end

        it 'sets the Constraints relation to :lesser_equal' do
          expect((@expression <= @other_expression).relation).to eq(:lesser_equal)
        end

        it 'sets the lhs of the Constraint to self' do
          expect((@expression <= @other_expression).lhs).to eql(@expression)
        end

        it 'sets the rhs of the Constraint to the other Expression' do
          expect((@expression <= @other_expression).rhs).to eql(@other_expression)
        end
      end
    end

    describe '#>=' do
      context 'when used with another Expression' do
        before(:each) do
          @other_expression = Expression.new(5.0)
        end

        it 'returns a Constraint' do
          expect(@expression >= @other_expression).to be_a(Constraint)
        end

        it 'sets the Constraints relation to :greater_equal' do
          expect((@expression >= @other_expression).relation).to eq(:greater_equal)
        end

        it 'sets the lhs of the Constraint to self' do
          expect((@expression >= @other_expression).lhs).to eql(@expression)
        end

        it 'sets the rhs of the Constraint to the other Expression' do
          expect((@expression >= @other_expression).rhs).to eql(@other_expression)
        end
      end
    end

    describe '#==' do
      context 'when used with another Expression' do
        before(:each) do
          @other_expression = Expression.new(5.0)
        end

        it 'returns a Constraint' do
          expect(@expression == @other_expression).to be_a(Constraint)
        end

        it 'sets the Constraints relation to :greater_equal' do
          expect((@expression == @other_expression).relation).to eq(:equal)
        end

        it 'sets the lhs of the Constraint to self' do
          expect((@expression == @other_expression).lhs).to eql(@expression)
        end

        it 'sets the rhs of the Constraint to the other Expression' do
          expect((@expression == @other_expression).rhs).to eql(@other_expression)
        end
      end
    end

    describe '#simplified' do
      it 'returns an Expression' do
        expect(Expression.new(1).simplified).to be_a(Expression)
      end

      it 'returns the Expression with no dupplications in the factors' do
        v1 = double('Variable')
        v2 = double('Variable')
        v3 = double('Variable')
        factors = Expression.new([[3, v1], [-2.0, v2], [-1, v1], [2, :constant], [2.5, v3], [1, v2], [-2.0, :constant], [3, :constant], [-2.5, v3]]).simplified.factors
        expect(factors).to include([2, v1])
        expect(factors).to include([-1.0, v2])
        expect(factors).to include([3.0, :constant])
      end

      it 'returns an Expression where no factors with scalar 0 appear' do
        v1 = double('Variable')
        v2 = double('Variable')
        v3 = double('Variable')
        expect(Expression.new([[3, v1], [-2.0, v2], [-1, v1], [2, :constant], [2.5, v3], [1, v2], [-2.0, :constant], [3, :constant], [-2.5, v3]]).simplified.factors.flatten).not_to include(v3)
      end
    end

    describe '#remove_constants' do
      it 'returns an Expression containing all but the constant factors' do
        model = Model.new
        v1 = model.x(1)
        v2 = model.x(2)
        v3 = model.x(3)
        factors = Expression.new([[3, v1], [-2.0, v2], [-1, v1], [2, :constant], [2.5, v3], [1, v2], [-2.0, :constant], [3, :constant], [-2.5, v3]]).remove_constants.factors
        expect(factors).to eq([[3, v1], [-2.0, v2], [-1, v1], [2.5, v3], [1, v2], [-2.5, v3]])
      end
    end

    describe '#constant_factor' do
      it 'returns the total constant factor' do
        model = Model.new
        v1 = model.x(1)
        v2 = model.x(2)
        v3 = model.x(3)
        expect(Expression.new([[3, v1], [-2.0, v2], [-1, v1], [2, :constant], [2.5, v3], [1, v2], [-2.0, :constant], [3, :constant], [-2.5, v3]]).constant_factor).to eq(3.0)
      end
    end

    describe '#lp_string' do
      it 'returns a string representation feasible for the LP file format' do
        model = Model.new
        v1 = model.x(1)
        v2 = model.x(2)
        v3 = model.x(3)
        expect(Expression.new([[3, v1], [-2.0, v2], [-1, v1], [2, :constant], [2.5, v3], [1, v2], [-2.0, :constant], [3, :constant], [-2.5, v3]]).lp_string).to eq('2 x1 - 1.0 x2 + 3.0')
      end
    end

  end
end