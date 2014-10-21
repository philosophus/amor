require 'amor/model'

module Amor
  describe Model do
    before(:each) do
      @model = Model.new
    end

    describe '#x' do
      it 'returns a variable' do
        expect(@model.x(1)).to be_a(Variable)
      end

      it 'returns the same variable for the same indices' do
        expect(@model.x(1)).to equal(@model.x(1))
      end

      it 'returns different variables for different indices' do
        expect(@model.x(1)).not_to equal(@model.x(2))
      end
    end
  end
end