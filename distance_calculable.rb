module DistanceCalculable
  def distance(place)
    @distance = Math.sqrt((@x_coordinate - place.x_coordinate) * (@x_coordinate - place.x_coordinate) +
                          (@y_coordinate - place.y_coordinate) * (@y_coordinate - place.y_coordinate))
  end
end
