module DistanceCalculable
  def distance(place)
    @distance = @coordinates.distance_from place.coordinates
  end
end
