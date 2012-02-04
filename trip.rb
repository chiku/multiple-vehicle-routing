require File.dirname(__FILE__) + '/center'
require File.dirname(__FILE__) + '/city'

class Trip
  attr_reader :places
  attr_accessor :permitted_load

  def initialize(*all_places)
    @places = Places.new *all_places
    @places_old = all_places
  end

  VALIDATIONS = [
    :begins_with_center?,
    :has_same_center_at_extremes?,
    :has_no_intermediate_center?,
    :has_unique_cities?
  ]

  def valid?
    not VALIDATIONS.any?{ |validation| not places.send validation }
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
    return true if equal? other
    return false unless other.instance_of? self.class
    places == other.places
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

  def total_load
    cities.reduce(0){|sum, city| sum + city.capacity}
  end
end
