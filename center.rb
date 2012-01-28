require File.dirname(__FILE__) + '/distance_calculable'
require File.dirname(__FILE__) + '/place_equivalence'

class Center
  attr_accessor :name, :coordinates, :x_coordinate, :y_coordinate, :capacity

  include DistanceCalculable, PlaceEquivalence

  def initialize(options)
    @name = options[:name]
    @coordinates = Coordinates.new(options[:x_coordinate], options[:y_coordinate])
    @x_coordinate = @coordinates.x
    @y_coordinate = @coordinates.y
    @capacity = options[:capacity]
  end

  def city?
    false
  end

  def center?
    true
  end
end
