module Amor
  class Expression

    @scalars

    def initialize(variable, scalar)
      @scalars = {variable => scalar}
    end
    
    def scalar_of(variable)
      @scalars[variable]
    end
  end
end