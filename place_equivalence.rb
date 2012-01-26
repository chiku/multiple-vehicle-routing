module PlaceEquivalence
  def equal?(other)
    self.eql?(other) or (other.instance_of?(self.class) and x_coordinate == other.x_coordinate and y_coordinate == other.y_coordinate and
                      capacity == other.capacity and name == other.name)
  end
  
  def ==(other)
    equal?(other)
  end
  
  def hash
    name.hash + x_coordinate.hash + y_coordinate.hash + capacity.hash
  end
end
