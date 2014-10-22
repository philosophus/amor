module Amor
  class Constraint
    attr_reader :lhs, :rhs, :relation

    def initialize(lhs, relation, rhs)
      @lhs = Expression.new(lhs)
      @rhs = Expression.new(rhs)
      @relation = relation
    end
  end
end
