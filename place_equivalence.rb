module PlaceEquivalence
  def ==(other)
    return true if self.equal? other
    return false unless other.instance_of? self.class
    coordinates == other.coordinates and capacity == other.capacity and name == other.name
  end
  
  def hash
    name.hash + coordinates.hash + capacity.hash
  end
end
