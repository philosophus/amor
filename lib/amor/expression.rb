module Amor
  class Expression

    attr_reader :factors

    def initialize(factors)
      @factors = factors
    end
    
    def +(value)
      Expression.new(self.factors + value.factors)
    end
  end
end