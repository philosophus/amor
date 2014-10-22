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

  end
end