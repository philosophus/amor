require 'amor/expression'

module Amor
  class Variable

    attr_reader :model, :index

    def initialize(model, index)
      @model = model
      @index = index
    end

    def * (scalar)
      Expression.new(self, scalar)
    end

  end
end