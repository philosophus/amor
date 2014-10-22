require 'amor/variable'

module Amor
  describe Variable do
    before(:each) do
      @model = double('Model')
      @variable = Variable.new(@model, 1)
    end

    describe '#*' do
      # Make sure it works with Integer and Float
      [5, 5.0].each do |number|
        context "used with a #{number.class} as scalar" do
          it "returns an Expression when called with #{number}" do
            expect(@variable * number).to be_a(Expression)
          end

          it "returns an Expression with one factor" do
            expect((@variable * number).factors.size).to eq(1)
          end

          it "returns an Expression with one factor consisting of given variable and the value it was called with" do
            expect((@variable * number).factors.first).to eq([number, @variable])
          end
        end
      end
    end

    describe '#+' do
      context 'when used with an expression' do
        before(:each) do
          @other_variable = double('Other Variable')
          @other_expression = Expression.new([[3.0, @other_variable]])
        end

        it 'returns an Expression' do
          expect(@variable + @other_expression).to be_a(Expression)
        end

        it 'returns an Expression with the factor of the variable set to 1' do
          expect((@variable + @other_expression).factors).to eq([[1, @variable], [3.0, @other_variable]])
        end
      end

      context 'when used with a variable' do
        before(:each) do
          @other_variable = Variable.new(@model,2)
        end

        it 'returns an Expression' do
          expect(@variable + @other_variable).to be_a(Expression)
        end

        it 'returns an Expression with the factor of the variables set to 1' do
          expect((@variable + @other_variable).factors).to eq([[1, @variable], [1, @other_variable]])
        end
      end


      [6, 6.0].each do |number|
        context "when used with a #{number.class}" do
          it 'returns an Expression' do
            expect(@variable + number).to be_a(Expression)
          end

          it 'returns an Expression with the first factor set to the variable and the second factor set to the constant' do
            expect((@variable + number).factors).to eq([[1, @variable], [number, :constant]])
          end
        end
      end
    end

    describe '#-' do
      context 'when used with an expression' do
        before(:each) do
          @other_variable = double('Other Variable')
          @other_expression = Expression.new([[3.0, @other_variable]])
        end

        it 'returns an Expression' do
          expect(@variable - @other_expression).to be_a(Expression)
        end

        it 'returns an Expression with the factor of the variable set to 1 and the negative expression' do
          expect((@variable - @other_expression).factors).to eq([[1, @variable], [-3.0, @other_variable]])
        end
      end

      context 'when used with a variable' do
        before(:each) do
          @other_variable = Variable.new(@model,2)
        end

        it 'returns an Expression' do
          expect(@variable - @other_variable).to be_a(Expression)
        end

        it 'returns an Expression with the factor of the first variable set to 1 and the second to -1' do
          expect((@variable - @other_variable).factors).to eq([[1, @variable], [-1, @other_variable]])
        end
      end
    end

    describe '#-@' do
      it 'returns an Expression' do
        expect(-@variable).to be_a(Expression)
      end

      it 'returns an Expression with the variables factor set to -1' do
        expect((-@variable).factors).to eq([[-1, @variable]])
      end
    end
  end
end
