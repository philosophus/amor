require 'amor/expression'

module Amor
  describe Expression do

    # Specs for Integer and Float
    context 'when the Type of the scalar might matter' do
      [2, 2.0].each do |scalar|
        before(:each) do
          @variable = double('Variable')
          @expression = Expression.new(@variable, scalar)
        end

        describe '#scalar_of' do
          it "returns the stored #{scalar.class} scalar when called with existing variable" do
            expect(@expression.scalar_of(@variable)).to eq(scalar)
          end
        end
      end
    end

    # Specs where Type of scalar is irrelevant
    context 'when the Type of the scalar mis irrelevant' do
      before(:each) do
        @variable = double('Variable')
        @expression = Expression.new(@variable, 3)
      end

      describe '#scalar_of' do
        it "returns 0 when called with a non exising variable" do
          expect(@expression.scalar_of(double('Other Variable'))).to eq(0)
        end
      end
    end
  end
end