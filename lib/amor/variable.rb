require 'amor/expression'

module Amor
  class Variable

    attr_reader :model, :index

    def initialize(model, index)
      @model = model
      @index = index
    end

    def *(scalar)
      Expression.new([[scalar, self]])
    end

    def +(value)
      if value.is_a? Expression
        Expression.new([[1, self]] + value.factors)
      elsif value.is_a? Variable
        Expression.new([[1,self], [1, value]])
      end
    end

    def -(value)
      if value.is_a? Expression
        Expression.new([[1, self]] + value.factors.map{|factor| [-factor[0], factor[1]]})
      elsif value.is_a? Variable
        Expression.new([[1,self], [-1, value]])
      end
    end

  end
end