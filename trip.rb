require File.dirname(__FILE__) + '/center'
require File.dirname(__FILE__) + '/city'

class Trip
  attr_reader :places
  attr_accessor :permitted_load

  def initialize(*options)
    if options.first.is_a? Hash
      options = options.first
      @places = options[:places]
      @permitted_load = options[:permitted_load]
    else
      all_places = *options
      @places = Places.new *all_places
    end
  end

  PLACES_VALIDATIONS = [
    :begins_with_center?,
    :has_same_center_at_extremes?,
    :has_no_intermediate_center?,
    :has_unique_cities?
  ]

  def valid?
    not PLACES_VALIDATIONS.any?{ |validation| not places.send validation }
  end

  def add(place)
    places.add place
  end

  def center
    places.first_place
  end

  def cities
    places.intermediates.places # TODO deal with object
  end

  def ==(other)
    return true if equal? other
    return false unless other.instance_of? self.class
    places == other.places or places.reverse == other.places
  end

  def hash
    places.hash
  end

  def total_distance
    places.round_trip_distance
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
