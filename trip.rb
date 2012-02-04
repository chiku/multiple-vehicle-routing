require File.dirname(__FILE__) + '/center'
require File.dirname(__FILE__) + '/city'

class Trip
  attr_reader :places
  attr_accessor :permitted_load

  def initialize(*all_places)
    @places = Places.new *all_places
    @places_old = all_places
  end

  def valid?
    return places.begins_with_center? && places.has_same_center_at_extremes? && (not places.has_intermediate_center?) && places.has_unique_cities?
    begins_and_ends_with_same_center? and not center_present_in_middle? and not cities_are_repeated?
  end

  def add(place)
    places.add place
    @places_old << place
  end

  def center
    places.first_place
  end

  def cities
    @places_old[1, @places_old.size - 2]
  end

  def ==(other)
    return true if self.equal? other
    return false unless other.instance_of? self.class
    center == other.center and cities_with_equivalent_order? other
  end

  def hash
    cities.hash + center.hash
  end

  def total_distance
    distance = 0
    (0..(@places_old.size - 2)).each do |index|
      distance += @places_old[index].distance(@places_old[index + 1])
    end
    distance
  end

  def overloaded?(load=permitted_load)
    total_load > load
  end

  def to_s
    places.to_s
  end

  private

  def begins_and_ends_with_same_center?
    places.begins_with_center? and places.has_same_center_at_extremes?
  end

  def center_present_in_middle?
    cities.each do |place|
      return true if place.center?
    end
    false
  end

  def cities_are_repeated?
    # one center is already repeated, so drop the first entity
    trip_without_first_entity = cities + [center]
    trip_without_first_entity.uniq != trip_without_first_entity
  end
  
  def cities_with_equivalent_order?(other_trip)
    other_trip_cities = other_trip.cities
    return false unless cities.length == other_trip_cities.length
    cities_with_identical_order?(other_trip.cities) or cities_with_identical_order?(other_trip.cities.reverse)
  end

  def cities_with_identical_order?(other_cities)
    cities.each_with_index do |city, index|
      return false if city != other_cities[index]
    end
    true
  end

  def total_load
    cities.reduce(0){|sum, city| sum + city.capacity}
  end
end
