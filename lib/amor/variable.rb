module Amor
  class Variable

    attr_reader :model, :index

    attr_accessor :type

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

    def internal_index
      @model.internal_index(self.index)
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

    def to_s
      "x(#{index})"
    end
  end
end