module Amor
  class Expression

    attr_reader :factors

    def initialize(value)
      if value.is_a? Array
        @factors = value
      elsif value.is_a? Expression
        @factors = value.factors
      elsif value.is_a? Variable
        @factors = [[1, value]]
      elsif value.is_a? Numeric
        @factors = [[value, :constant]]
      end
    end

    def +(value)
      Expression.new(self.factors + Expression.new(value).factors)
    end

    def -(value)
      self + -value
    end

    def -@
      return Expression.new(self.factors.map{|factor| [-factor[0], factor[1]]})
    end

    def hash
      @factors.hash
    end

    def eql? value
      self == value
    end

    def == value
      self.hash == value.hash
    end

    def <= value
      Constraint.new(self, :lesser_equal, value)
    end
  end
end