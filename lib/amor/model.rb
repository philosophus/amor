require 'amor/objective'

module Amor
  class Model

    attr_reader :objective, :constraints

    def initialize
      @variables = Array.new
      @indices = Hash.new
      @constraints = Array.new
    end

    # Return the variable for that index if already existing or a new one
    def x(index)
      @variables[@indices[index] ||= @indices.size] ||= Variable.new(self, index)
    end

    # Add a minimization objective
    def min(expression)
      @objective = Objective.new(:minimize, expression)
    end

    # Add a maximization objective
    def max(expression)
      @objective = Objective.new(:maximize, expression)
    end

    # Add a constraint
    def st(constraint)
      @constraints << constraint
      return constraint
    end

    # Create a model from a given string
    def self.from_string(string)
      model = Model.new
      model.instance_eval(string)
      return model
    end

    # Create a model from a file
    def self.from_file(filename)
      Model.from_string(File.read(filename))
    end

    def internal_index(index)
      @indices[index]
    end

    def lp_string
      result = @objective.lp_string
      result << "\nSubject To\n"
      result << @constraints.each_with_index.map do |constraint, i|
        " c#{i+1}: #{constraint.lp_string}"
      end.join("\n")
      result << "\nEnd"
      return result
    end

    def save_lp(filename)
      File.open(filename, 'w') {|file| file.puts self.lp_string}
    end

    def for_all(container)
      container.each do |e|
        result = yield(e)
        if result.is_a?(Constraint)
          self.st result
        end
      end
      return nil
    end

    def sum(container)
      container[1..-1].inject(yield(container[0])) do |m, e|
        m + yield(e)
      end
    end
  end
end