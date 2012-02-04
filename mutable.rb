module Mutable
  def mutate!
    position_1, position_2 = rand(@places.size), rand(@places.size)

    return self unless (position_1 == position_2) or (not mutation_agreable?(position_1, position_2))
    @places[position_1], @places[position_2] = @places[position_2], @places[position_1]
    p @places[position_1], @places[position_2]
    split_into_trips
    self
  end

  def mutation_agreable?(position_1, position_2)
    (@places[position_1].city? and @places[position_2].city?) or (@places[position_1].center? and @places[position_2].center?)
  end
end