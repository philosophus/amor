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

      it 'stores the index, which the constraint has in the model' do
        @model.st(@constraint)
        expect(@model.constraints[0].index).to eq(0)
      end

      it 'adds constraint to block if a block is given' do
        @model.block do
          @model.st(@constraint)
        end
        expect(@model.blocks.last.constraints).to include(@constraint)
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
        model = Model.from_string("min x(3) + 3 * x(2) + 4.0\nst x(2) - 2.0 * x(3) <= 5.0\nbinary x(2)\npositive integer x(3)")
        expect(model.lp_string).to eq("Minimize\n obj: 1 x1 + 3 x2 + 4.0\nSubject To\n c1: 1 x2 - 2.0 x1 <= 5.0\nBounds\n 0 <= x1\nGenerals\n x1\nBinary\n x2\nEnd")
      end
    end

    describe '#for_all' do
      it 'repeats the block for each element in the provided collection' do
        expect { |b| @model.for_all([1,2,3], &b) }.to yield_control.exactly(3).times
      end

      it 'calls the block with the elements from the provided collection' do
        expect { |b| @model.for_all([1,2,4], &b) }.to yield_successive_args(1,2,4)
      end

      it 'returns nil' do
        expect(@model.for_all([1,2]) {}).to eq(nil)
      end

      it 'registers a Constraint with the model' do
        c = []
        @model.for_all([1,2]) {|i| c[i] = (@model.x(i) <= i)}
        expect(@model.constraints).to include(c[1])
        expect(@model.constraints).to include(c[2])
      end
    end

    describe '#sum' do
      it 'returns an Expression' do
        expect(@model.sum([1,2]) {|i| @model.x(i)}).to be_a(Expression)
      end

      it 'sums up the results from the provided block for each element in the collection' do
        expect(@model.sum([1,2,3]) {|i| i * @model.x(i)}).to eql(@model.x(1) + 2 * @model.x(2) + 3 * @model.x(3))
      end
    end

    describe '#integer' do
      it 'returns a Variable' do
        expect(@model.integer(@model.x(1))).to be_a(Variable)
      end

      it 'sets the type of the Variable to :integer' do
        @model.integer(@model.x(1))
        expect(@model.x(1).type).to eq(:integer)
      end
    end

    describe '#binary' do
      it 'returns a Variable' do
        expect(@model.binary(@model.x(1))).to be_a(Variable)
      end

      it 'sets the type of the Variable to :binary' do
        @model.binary(@model.x(1))
        expect(@model.x(1).type).to eq(:binary)
      end
    end

    describe '#positive' do
      it 'returns a Variable' do
        expect(@model.positive(@model.x(1))).to be_a(Variable)
      end

      it 'sets the variables lower bound to 0' do
        @model.positive(@model.x(1))
        expect(@model.x(1).lb).to eq(0)
      end
    end

    describe '#block' do
      it 'yields' do
        expect { |b| @model.block(&b) }.to yield_control
      end

      it 'sets @in_block to current block within yield' do
        @model.block do
          expect(@model.instance_variable_get('@in_block').class).to eq(Block)
        end
      end

      it 'sets @in_block to nil before leaving' do
        @model.block do
        end
        expect(@model.instance_variable_get('@in_block')).to eq(nil)
      end

      it 'adds a new block to the model' do
        @model.block { }
        expect(@model.blocks.size).to eq(1)
      end
    end

    describe '#dec_string' do
      it 'returns a string representation of specified decomposition in .dec file format' do
        @model.st(@model.x(1) + @model.x(2) >= 3)
        @model.block do
          @model.st(@model.x(1) + @model.x(3) <= 1)
          @model.st(@model.x(2) - @model.x(4) <= 2)
        end
        @model.block do
          @model.st(@model.x(1) - @model.x(5) >= 1)
        end
        @model.st(@model.x(3) + @model.x(4) == 2)
        expect(@model.dec_string).to eq("PRESOLVED 0\nNBLOCKS 2\nBLOCK 1\nc2\nc3\nBLOCK 2\nc4\nMASTERCONSS\nc1\nc5")
      end
    end
  end
end