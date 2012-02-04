require File.dirname(__FILE__) + '/center'
require File.dirname(__FILE__) + '/city'
require File.dirname(__FILE__) + '/trip'
require File.dirname(__FILE__) + '/mutable'

class Route
  include Mutable

  attr_reader :places, :trips
  attr_accessor :permitted_load

  def initialize(*places)
    @places = places
    split_into_trips
  end

  def ==(other)
    return true if equal? other
    return false unless other.instance_of? self.class
    self.contains_trips? other.trips
  end

  def valid?
    not (begins_with_city? or ends_with_center? or places_are_repeated? or centers_occur_together?)
  end
    
  def total_distance
    @trips.inject(0) {|distance, trip| distance + trip.total_distance}
  end
  
  def total_overloads(load = permitted_load)
    @trips.inject(0) {|overloads, trip| overloads + (trip.overloaded?(load) ? 1 : 0)}
  end
  
  def fitter_than?(other_route)
    return (total_distance < other_route.total_distance) if total_overloads == other_route.total_overloads
    total_overloads < other_route.total_overloads
  end
  
  def contains_trips?(trip_list)
    trip_list.size == trips.size and (trip_list.collect{|trip| contains_trip?(trip)}).inject{|result, item| result and item}
  end
  
  def contains_trip?(trip)
    trip.instance_of?(Trip) and trips.include?(trip)
  end
  
  def to_s
    @trips.collect{|trip| trip.to_s}.join(' ')
  end
  
  private 
  
  def begins_with_city?
    @places.first.city?
  end
  
  def ends_with_center?
    @places.last.center?
  end
  
  def places_are_repeated?
    @places.uniq != @places
  end
  
  def centers_occur_together?
    @places.each_with_index do |place, index|
      return true if place.center? and @places[index - 1].center?
    end
    false
  end

  def split_into_trips
    @trips = [Trip.new(:places => Places.new(@places.first))]
    current_trip = 0
    @places[1, @places.size].each do |place|
      add_to_trip_number(place, current_trip) if place.city?
      if place.center?
        add_to_trip_number(@trips[current_trip].center, current_trip)
        current_trip += 1
        @trips << Trip.new(:places => Places.new(place))
      end
    end
    add_to_trip_number(@trips[current_trip].center, current_trip)
  end

  def add_to_trip_number(place, trip_number)
    @trips[trip_number].add(place)
  end
end
