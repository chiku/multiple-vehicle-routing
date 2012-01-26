require File.dirname(__FILE__) + '/distance_calculable'
require File.dirname(__FILE__) + '/place_equivalence'

class City
  attr_accessor :name, :x_coordinate, :y_coordinate, :capacity
  
  include DistanceCalculable, PlaceEquivalence
  
  def initialize(options)
    @name = options[:name]
    @x_coordinate = options[:x_coordinate]
    @y_coordinate = options[:y_coordinate]
    @capacity = options[:capacity]
  end
  
  def city?
    true
  end
  
  def center?
    false
  end
end
