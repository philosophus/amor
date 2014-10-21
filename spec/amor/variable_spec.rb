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
  end
end
