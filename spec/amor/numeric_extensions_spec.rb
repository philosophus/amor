require 'amor/numeric_extensions'

module Amor
  [5, 5.0].each do |number|
    describe "#{number.class}" do
      describe '#*' do
        context 'when used with a variable' do
          before(:each) do
            @variable = Variable.new(double('Model'), 1)
          end

          it 'returns an Expression' do
            expect(number * @variable).to be_a(Expression)
          end

          it 'returns an Expression with the factor of the variable set to the number' do
            expect((number * @variable).factors).to eq([[number, @variable]])
          end
        end
      end

      describe '#+' do
        context 'when used with an expression' do
          before(:each) do
            @variable = double('Variable')
            @expression = Expression.new([[@variable, 2.0]])
          end

          it 'returns an Expression' do
            expect(number + @expression).to be_a(Expression)
          end

          it 'returns an Expression with the first factor set to the constant' do
            expect((number + @expression).factors).to eq([[number, :constant], [@variable, 2.0]])
          end
        end
      end
    end
  end
end