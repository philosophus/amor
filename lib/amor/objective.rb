module Amor
  class Objective

    attr_reader :direction, :expression

    def initialize(direction, expression)
      @direction = direction
      @expression = Expression.new(expression)
    end

  end
end