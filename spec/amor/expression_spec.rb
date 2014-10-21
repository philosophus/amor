require 'amor/expression'

module Amor
  describe Expression do
    before(:each) do
      @variable = double('Variable')
      @expression = Expression.new([[2, @variable]])
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
    end

    describe '#-@' do
      it 'returns an Expression' do
        expect(-@expression).to be_a(Expression)
      end

      it 'returns an Expression with the negative factors' do
        expect((-@expression).factors).to eq([[-2, @variable]])
      end
    end
  end
end