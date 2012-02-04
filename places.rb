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

  def has_center?
    places.any?(&:center?)
  end

  def ends_with_center?
    last_place.center?
  end

  def ends_with_city?
    last_place.city?
  end

  def has_same_center_at_extremes?
    begins_with_center? and first_place == last_place
  end

  def has_unique_places?
    uniq_list? places
  end

  def has_unique_cities?
    uniq_list? places.select(&:city?)
  end

  def uniq_list? list
    list.uniq.size == list.size
  end
  private :uniq_list?

  def intermediates
    Places.new *places[1..-2]
  end

  def has_no_intermediate_center?
    not intermediates.has_center?
  end

  def has_no_consecutive_center?
    places.each_cons(2).none? { |place_1, place_2| place_1.center? and place_2.center? }
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

  def round_trip_distance
    places.each_cons(2).map{ |from, to| from.distance to }.reduce(0, &:+)
  end
end
