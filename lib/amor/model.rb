require 'amor/objective'

module Amor
  class Model

    attr_reader :constraints, :solved, :bounded, :blocks

    def initialize
      @variables = Array.new
      @indices = Hash.new
      @constraints = Array.new
    end

    # Return the variable for that index if already existing or a new one
    def x(index)
      variable = @variables[@indices[index] ||= @indices.size] ||= Variable.new(self, index)
      if @solved
        variable.value || 0
      else
        variable
      end
    end
    alias :var :x

    def objective
      if @solved
        @objective_value
      else
        @objective
      end
    end
    alias :obj :objective


    # Add a minimization objective
    def min(expression)
      @objective = Objective.new(:minimize, expression)
    end
    alias :minimize :min

    # Add a maximization objective
    def max(expression)
      @objective = Objective.new(:maximize, expression)
    end
    alias :maximize :max

    # Add a constraint
    def st(constraint)
      constraint.index = @constraints.size
      @constraints << constraint
      @in_block.add_constraint(constraint) if @in_block
      return constraint
    end
    alias :subject_to :st

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
        " #{constraint.lp_string}"
      end.join("\n")

      # Bounds section
      bounded_vars = @variables.each_with_index.select{|v| v[0].lb}
      result << "\nBounds" if bounded_vars.size > 0
      bounded_vars.each{|v| result << "\n 0 <= x#{v[1]+1}"}

      # Variable type section
      integer_vars = @variables.each_with_index.select{|v| v[0].type == :integer}
      result << "\nGenerals\n " if integer_vars.size > 0
      result << integer_vars.map{|v| "x#{v[1]+1}"}.join(" ")

      binary_vars = @variables.each_with_index.select{|v| v[0].type == :binary}
      result << "\nBinary\n " if binary_vars.size > 0
      result << binary_vars.map{|v| "x#{v[1]+1}"}.join(" ")

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
    alias :forall :for_all

    def sum(container)
      container[1..-1].inject(yield(container[0])) do |m, e|
        m + yield(e)
      end
    end

    def integer(variable)
      variable.type = :integer
      return variable
    end
    alias :int :integer

    def binary(variable)
      variable.type = :binary
      return variable
    end
    alias :bin :binary

    def positive(variable)
      variable.lb = 0
      return variable
    end

    def scip
      self.save_lp('__temp.lp')
      scip_result = `scip -f __temp.lp`
      File.open('scip.log', 'w') {|file| file.puts scip_result}
      File.delete('__temp.lp')

      parse_scip_output scip_result

    rescue Errno::ENOENT => e
      puts "Could not find SCIP. Please make sure that SCIP is installed and you can execute 'scip'."
      raise e
    end

    def parse_scip_output(scip_result)
      solution_section = false
      scip_result.each_line do |line|
        if !@solved && line =~ /problem is solved \[([\w\s]*)\]/
          @solved = true
          if $1 == 'optimal solution found'
            @bounded = true
          elsif $1 == 'unbounded'
            @bounded = false
          elsif $1 == 'infeasible'
            @infeasible = true
          else
            raise "Unknown solve status: #{$1}"
          end
        end

        solution_section = true if line =~ /primal solution:/
        solution_section = false if line =~ /Statistics/n

        if solution_section
          @objective_value = $1 if line =~ /objective value:\s*([\.\d]+)/
          if line =~ /x(\d+)\s*([\.\d]+)/
            @variables[$1.to_i-1].value = $2.to_f
          end
        end
      end
    end

    # Creates a new block and makes sure that constraints added in yield are added to block
    def block
      (@blocks ||= Array.new) << Block.new
      @in_block = @blocks.last
      yield
      @in_block = nil
    end

    def dec_string
      result = ["PRESOLVED 0", "NBLOCKS #{@blocks.size}"]

      @blocks.each_with_index do |block, i|
        result << block.dec_string(i + 1)
      end

      result << "MASTERCONSS"
      # Remaining constraints
      @blocks.inject(@constraints) {|mem, block| mem - block.constraints}.each do |constraint|
        result << constraint.lp_name
      end

      result.join("\n")
    end

    def save_dec(filename)
      File.open(filename, 'w') {|file| file.puts self.dec_string}
    end

    def gcg
      self.save_lp('__temp.lp')
      self.save_dec('__temp.dec')
      gcg_result = `gcg -f __temp.lp -d __temp.dec`
      File.open('gcg.log', 'w') {|file| file.puts gcg_result}
      File.delete('__temp.lp')
      File.delete('__temp.dec')

      parse_scip_output gcg_result

    rescue Errno::ENOENT => e
      puts "Could not find GCG. Please make sure that GCG is installed and you can execute 'gcg'."
      raise e
    end
  end
end