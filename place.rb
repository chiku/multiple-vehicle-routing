require File.dirname(__FILE__) + '/coordinates'

class Place
  attr_accessor :name, :coordinates, :capacity

  def initialize(options)
    @name = options[:name]
    @coordinates = Coordinates.new(options[:x_coordinate], options[:y_coordinate])
    @capacity = options[:capacity]
  end

  def ==(other)
    return true if self.equal? other
    return false unless other.instance_of? self.class
    coordinates == other.coordinates and capacity == other.capacity and name == other.name
  end
  
  def hash
    name.hash + coordinates.hash + capacity.hash
  end

  def distance(place)
    @distance = @coordinates.distance_from place.coordinates
  end
end

class BlankPlace
  def ==(other)
    false
  end

  def city?
    false
  end

  def center?
    false
  end
end