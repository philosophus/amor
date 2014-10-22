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

      it 'stores the model in the variable' do
        expect(@model.x(1).model).to equal(@model)
      end

      it 'stores the index in the variable' do
        expect(@model.x(1).index).to equal(1)
      end
    end

    describe '#min' do
      before(:each) do
        @expression = Expression.new([[3, double('Variable')], [-2, double('Variable')]])
      end

      it 'returns an Objective' do
        expect(@model.min(@expression)).to be_a(Objective)
      end

      it 'returns an Objective with the direction set to :min' do
        expect(@model.min(@expression).direction).to eq(:minimize)
      end

      it 'returns an Objective with the expression set to the given Expression' do
        expect(@model.min(@expression).expression).to equal(@expression)
      end

      it 'stores the objective in the model' do
        objective = @model.min(@expression)
        expect(@model.objective).to equal(objective)
      end
    end

    describe '.from_string' do
      before(:each) do
        @string = "x(3) + 3 * x(2) + 4.0"
      end

      it 'returns a Model' do
        expect(Model.from_string(@string)).to be_a(Model)
      end
    end
  end
end