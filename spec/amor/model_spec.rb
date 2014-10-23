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
        expect(@model.min(@expression).expression).to eql(@expression)
      end

      it 'stores the objective in the model' do
        objective = @model.min(@expression)
        expect(@model.objective).to equal(objective)
      end
    end

    describe '#max' do
      before(:each) do
        @expression = Expression.new([[3, double('Variable')], [-2, double('Variable')]])
      end

      it 'returns an Objective' do
        expect(@model.max(@expression)).to be_a(Objective)
      end

      it 'returns an Objective with the direction set to :max' do
        expect(@model.max(@expression).direction).to eq(:maximize)
      end

      it 'returns an Objective with the expression set to the given Expression' do
        expect(@model.max(@expression).expression).to eql(@expression)
      end

      it 'stores the objective in the model' do
        objective = @model.max(@expression)
        expect(@model.objective).to equal(objective)
      end
    end

    describe '#st' do
      before(:each) do
        @constraint = Constraint.new(1, :greater_equal, Variable.new(double('Model'), 1))
      end

      it 'returns the given Constraint' do
        expect(@model.st(@constraint)).to equal(@constraint)
      end

      it 'stores the constraint in the model' do
        @model.st(@constraint)
        expect(@model.constraints).to include(@constraint)
      end
    end


    describe '.from_string' do
      before(:each) do
        @string = "min x(3) + 3 * x(2) + 4.0\nst x(2) - 2.0 * x(3) <= 5.0"
      end

      it 'returns a Model' do
        expect(Model.from_string(@string)).to be_a(Model)
      end

      it 'returns a Model with the specified objective' do
        model = Model.from_string(@string)
        expect(model.objective.expression.factors).to eq([[1, model.x(3)], [3, model.x(2)], [4.0, :constant]])
      end

      it 'returns a Model with the specified constraint' do
        model = Model.from_string(@string)
        expect(model.constraints[0].lhs.factors).to eq([[1, model.x(2)], [-2.0, model.x(3)]])
      end
    end

    describe '#lp_string' do
      it 'returns a LP Format ready string of the model' do
        model = Model.from_string("min x(3) + 3 * x(2) + 4.0\nst x(2) - 2.0 * x(3) <= 5.0")
        expect(model.lp_string).to eq("Minimize\n obj: 1 x1 + 3 x2 + 4.0\nSubject To\n c1: 1 x2 - 2.0 x1 <= 5.0\nEnd")
      end
    end

    describe '#for_all' do
      it 'repeats the block for each element in the provided collection' do
        expect { |b| @model.for_all([1,2,3], &b) }.to yield_control.exactly(3).times
      end

      it 'calls the block with the elements from the provided collection' do
        expect { |b| @model.for_all([1,2,4], &b) }.to yield_successive_args(1,2,4)
      end
    end
  end
end