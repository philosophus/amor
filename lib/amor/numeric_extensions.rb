class Fixnum
  old_multiplication = instance_method(:'*')

  define_method(:'*') do |value|
    if value.is_a? Amor::Variable
      Amor::Expression.new([[self, value]])
    else
      old_multiplication.bind(self).(value)
    end
  end
end