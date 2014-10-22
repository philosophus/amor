require 'amor/variable'
require 'amor/expression'

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
    if value.is_a?(Amor::Expression) || value.is_a?(Amor::Variable)
      Amor::Expression.new(self) + Amor::Expression.new(value)
    else
      old_addition.bind(self).(value)
    end
  end

  old_subtraction = instance_method(:'-')
  define_method(:'-') do |value|
    if value.is_a?(Amor::Expression) || value.is_a?(Amor::Variable)
      self + -value
    else
      old_subtraction.bind(self).(value)
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
    if value.is_a?(Amor::Expression) || value.is_a?(Amor::Variable)
      Amor::Expression.new(self) + Amor::Expression.new(value)
    else
      old_addition.bind(self).(value)
    end
  end

  old_subtraction = instance_method(:'-')
  define_method(:'-') do |value|
    if value.is_a?(Amor::Expression) || value.is_a?(Amor::Variable)
      self + -value
    else
      old_subtraction.bind(self).(value)
    end
  end
end