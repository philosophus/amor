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
      self.hash == value.hash
    end

    def == value
      Constraint.new(self, :equal, value)
    end

    def <= value
      Constraint.new(self, :lesser_equal, value)
    end

    def >= value
      Constraint.new(self, :greater_equal, value)
    end

    def simplified
      summed_scalars = Hash.new
      @factors.each do |factor|
        summed_scalars[factor[1]] = (summed_scalars[factor[1]] || 0) + factor[0]
      end
      Expression.new(summed_scalars.map{|var, scalar| [scalar, var]}.select{|factor| !factor[0].zero? })
    end

    def remove_constants
      Expression.new(@factors.select{|factor| factor[1] != :constant})
    end

  end
end