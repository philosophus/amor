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
      Expression.new(self) + Expression.new(value)
    end

    def -(value)
      self + -value
    end

    def -@
      Expression.new([[-1, self]])
    end
  end
end