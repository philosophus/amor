module Amor
  class Expression

    attr_reader :factors

    def initialize(factors)
      @factors = factors
    end

    def +(value)
      if value.is_a? Expression
        Expression.new(self.factors + value.factors)
      elsif value.is_a? Variable
        Expression.new(self.factors + [[1, value]])
      end
    end

    def -(value)
      self + -value
    end

    def -@
      return Expression.new(self.factors.map{|factor| [-factor[0], factor[1]]})
    end
  end
end