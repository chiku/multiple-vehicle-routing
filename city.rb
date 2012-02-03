require File.dirname(__FILE__) + '/coordinates'
require File.dirname(__FILE__) + '/distance_calculable'
require File.dirname(__FILE__) + '/place_equivalence'

class City
  attr_accessor :name, :coordinates, :capacity

  include DistanceCalculable, PlaceEquivalence

  def initialize(options)
    @name = options[:name]
    @coordinates = Coordinates.new(options[:x_coordinate], options[:y_coordinate])
    @capacity = options[:capacity]
  end

  def city?
    true
  end

  def center?
    false
  end
end
