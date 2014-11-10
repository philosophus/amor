module Amor
  class Block
    attr_accessor :constraints

    def initialize
      @constraints = Array.new
    end

    def add_constraint constraint
      @constraints << constraint
    end
  end
end