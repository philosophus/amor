module Amor
  class Block
    attr_reader :constraints

    def initialize
      @constraints = Array.new
    end

    def add_constraint constraint
      @constraints << constraint
    end

    # Returns a representation for .dec file format of this block
    # It assumes the block has the specified index
    def dec_string index
      result = ["BLOCK #{index}"]
      @constraints.each do | constraint |
        result << constraint.lp_name
      end

      result.join("\n")
    end
  end
end