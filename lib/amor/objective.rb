module Amor
  class Objective

    attr_reader :direction, :expression

    def initialize(direction, expression)
      @direction = direction
      @expression = Expression.new(expression)
    end

    def lp_string
      direction_string = (@direction == :maximize ? "Maximize" : "Minimize")
      "#{direction_string}\n obj: #{@expression.lp_string}"
    end

  end
end