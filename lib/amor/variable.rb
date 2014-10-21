class Amor::Variable

  attr_reader :model, :index

  def initialize(model, index)
    @model = model
    @index = index
  end

end