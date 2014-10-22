require 'amor/objective'

module Amor
  describe Objective do
    describe '#lp_string' do
      it 'returns LP format ready version of objective, starting with Maximize if direction is :maximize' do
        expect(Objective.new(:maximize, Expression.new(2)).lp_string).to eq("Maximize\n obj: 2")
      end
      it 'returns LP format ready version of objective, starting with Minimize if direction is :minimize' do
        expect(Objective.new(:minimize, Expression.new(2)).lp_string).to eq("Minimize\n obj: 2")
      end
    end
  end
end