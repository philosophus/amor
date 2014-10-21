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
        it "returns an Expression when called with #{number}" do
          expect(@variable * number).to be_a(Expression)
        end

        it "returns an Expression with scalar of #{number} for given variable when called with #{number}" do
          expect((@variable * number).scalar_of(@variable)).to eq(number)
        end
      end
    end
  end
end
