require 'forwardable'
require File.dirname(__FILE__) + '/center'
require File.dirname(__FILE__) + '/city'

class Trip
  attr_reader :places
  attr_accessor :permitted_load

  extend Forwardable

  def initialize(options = {})
    @places = options[:places] || Places.new
    @permitted_load = options[:permitted_load] || 0
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

  def ==(other)
    return true if equal? other
    return false unless other.instance_of? self.class
    places == other.places or places.reverse == other.places
  end

  def_delegators :places, :add, :hash, :to_s, :round_trip_distance

  def center
    places.first_place
  end

  def cities
    places.intermediates.places # TODO deal with object
  end

  def total_load
    cities.reduce(0){|sum, city| sum + city.capacity}
  end

  def overloaded?(load=permitted_load) #TODO remove parameter
    total_load > load
  end
end
