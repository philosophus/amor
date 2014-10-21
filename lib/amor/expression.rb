module Amor
  class Expression

    attr_reader :factors

    def initialize(variable, scalar)
      @factors = [[scalar, variable]]
    end
    
  end
end