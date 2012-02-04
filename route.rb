require File.dirname(__FILE__) + '/center'
require File.dirname(__FILE__) + '/city'
require File.dirname(__FILE__) + '/trip'
require File.dirname(__FILE__) + '/mutable'

class Route
  include Mutable

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

  private

  def split_into_trips
    @trips = [Trip.new(:places => Places.new(places.first_place))]

    current_trip = 0
    places.places[1, places.places.size].each do |place|
      if place.city?
        add_to_trip_number(place, current_trip)
      end
      if place.center?
        add_to_trip_number(trips[current_trip].center, current_trip)
        current_trip += 1
        trips << Trip.new(:places => Places.new(place))
      end
    end

    add_to_trip_number(trips[current_trip].center, current_trip)
  end

  def add_to_trip_number(place, trip_number)
    trips[trip_number].add(place)
  end
end
