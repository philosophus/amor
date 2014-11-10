module Amor
  class Constraint
    attr_reader :lhs, :rhs, :relation
    attr_accessor :lp_name # The name the constraint assumes in an LP file

    def initialize(lhs, relation, rhs)
      @lhs = Expression.new(lhs)
      @rhs = Expression.new(rhs)
      @relation = relation
    end

    def lp_string
      temp_lhs = (@lhs - @rhs).simplified
      relation_string = case @relation
        when :greater_equal
          ">="
        when :lesser_equal
          "<="
        else
          "="
        end

      "#{temp_lhs.remove_constants.lp_string} #{relation_string} #{-temp_lhs.constant_factor}"
    end

    def to_s
      relation_string = case @relation
        when :greater_equal
          ">="
        when :lesser_equal
          "<="
        else
          "=="
        end
      "#{@lhs} #{relation_string} #{@rhs}"
    end
  end
end
