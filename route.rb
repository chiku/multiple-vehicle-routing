require File.dirname(__FILE__) + '/center'
require File.dirname(__FILE__) + '/city'
require File.dirname(__FILE__) + '/trip'

class Route
  attr_reader :places, :trips, :permitted_load

  def initialize(options = {})
    @places = options[:places] || Places.new
    @permitted_load = options[:permitted_load] || 0
    split_into_trips
  end

  PLACES_VALIDATIONS = [
    :begins_with_center?,
    :ends_with_city?,
    :has_unique_places?,
    :has_no_consecutive_center?
  ]

  def valid?
    not PLACES_VALIDATIONS.any? { |validation| not places.send validation }
  end

  def ==(other)
    return true if equal? other
    return false unless other.instance_of? self.class
    contains_trips? other.trips
  end

  def total_distance
    trips.map(&:round_trip_distance).reduce(0, &:+)
  end

  def total_overloads
    trips.reduce(0) { |acc, trip| acc + (trip.overloaded?(permitted_load) ? 1 : 0) }
  end

  def fitter_than?(other_route)
    return (total_distance < other_route.total_distance) if total_overloads == other_route.total_overloads
    total_overloads < other_route.total_overloads
  end

  def contains_trips?(trip_list)
    trip_list.size == trips.size and (trip_list.collect{|trip| contains_trip?(trip)}).inject{|result, item| result and item}
  end

  def contains_trip?(trip)
    trip.is_a? Trip and trips.include? trip
  end

  def to_s
    trips.map(&:to_s).join(' ')
  end

  def mutate!
    position_1, position_2 = rand(places.size), rand(places.size)
    places.interchange_positions!(position_1, position_2) if places.equivalent_positions?(position_1, position_2)
    split_into_trips
    self
  end

  def split_into_trips
    @trips = places.split_by_leading_center.map(&:replicate_first_place_to_end).map{ |places| Trip.new :places => places }
  end
  private :split_into_trips
end
