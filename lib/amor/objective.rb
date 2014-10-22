module Amor
  class Objective

    attr_reader :direction, :expression

    def initialize(direction, expression)
      @direction = direction
      @expression = expression
    end

  end
end