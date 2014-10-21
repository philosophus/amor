require 'amor/numeric_extensions'

module Amor
  describe Fixnum do
    describe '#*' do
      context 'when used with a variable' do
        before(:each) do
          @variable = Variable.new(double('Model'), 1)
        end

        it 'returns an Expression' do
          expect(5 * @variable).to be_a(Expression)
        end

        it 'returns an Expression with the factor of the variable set to the number' do
          expect((5 * @variable).factors).to eq([[5, @variable]])
        end
      end
    end
  end
end