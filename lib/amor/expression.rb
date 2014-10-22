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

    def constant_factor
      @factors.select{|factor| factor[1] == :constant}.inject(0) {|m, factor| m + factor[0]}
    end

    def lp_string
      result = ''
      factor_strings = self.simplified.factors.each_with_index.map do |factor, i|
        scalar = factor[0]
        if scalar < 0
          sign = '- '
          scalar = -scalar
        elsif i > 0
          sign = '+ '
        else
          sign = ''
        end

        if factor[1] == :constant
          "#{sign}#{scalar}"
        else
          "#{sign}#{scalar} x#{factor[1].internal_index+1}"
        end
      end
      return factor_strings.join(' ')
    end
  end
end