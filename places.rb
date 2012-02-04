require File.dirname(__FILE__) + '/place'
require File.dirname(__FILE__) + '/city'
require File.dirname(__FILE__) + '/center'

class Places
  attr_reader :places

  def initialize(*places)
    @places = places
  end

  def first_place
    places.first or BlankPlace.new
  end

  def begins_with_center?
    first_place.center?
  end

  def last_place
    places.last or BlankPlace.new
  end

  def ends_with_center?
    last_place.center?
  end

  def has_same_center_at_extremes?
    begins_with_center? and first_place == last_place
  end

  def has_unique_cities?
    cities = places.select(&:city?)
    cities.uniq.size == cities.size
  end

  def has_no_intermediate_center?
    not places[1..-2].any?(&:center?)
  end

  def add place
    places << place
  end

  def to_s
    "(" + places.map(&:name).join(' -> ') + ")"
  end

  def ==(other)
    return true if equal? other
    return false unless other.instance_of? self.class
    places == other.places
  end

  def hash
    places.hash
  end

  def reverse
    Places.new *places.reverse
  end

  def intermediates
    Places.new(*places[1..-2])
  end

  def round_trip_distance
    sum = 0
    places.each_cons(2) { |from, to| sum += from.distance to }
    sum
  end
end
