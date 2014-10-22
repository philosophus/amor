class Fixnum
  old_multiplication = instance_method(:'*')

  define_method(:'*') do |value|
    if value.is_a? Amor::Variable
      value * self
    else
      old_multiplication.bind(self).(value)
    end
  end

  old_addition = instance_method(:'+')

  define_method(:'+') do |value|
    if value.is_a? Amor::Expression
      Amor::Expression.new([[self, :constant]] + value.factors)
    else
      old_addition.bind(self).(value)
    end
  end
end

class Float
  old_multiplication = instance_method(:'*')

  define_method(:'*') do |value|
    if value.is_a? Amor::Variable
      value * self
    else
      old_multiplication.bind(self).(value)
    end
  end

  old_addition = instance_method(:'+')

  define_method(:'+') do |value|
    if value.is_a? Amor::Expression
      Amor::Expression.new([[self, :constant]] + value.factors)
    else
      old_addition.bind(self).(value)
    end
  end
end