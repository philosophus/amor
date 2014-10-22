require 'amor/objective'

module Amor
  class Model

    attr_reader :objective

    def initialize
      @variables = Array.new
      @indices = Hash.new
    end

    # Return the variable for that index if already existing or a new one
    def x(index)
      @variables[@indices[index] ||= @indices.size] ||= Variable.new(self, index)
    end

    def min(expression)
      @objective = Objective.new(:minimize, expression)
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

  end
end