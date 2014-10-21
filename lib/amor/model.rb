require 'amor/variable'

module Amor
  class Model

    def initialize
      @variables = Array.new
      @indices = Hash.new
    end

    # Return the variable for that index if already existing or a new one
    def x(index)
      @variables[@indices[index] ||= @indices.size] ||= Variable.new(self, index)
    end

  end
end