# frozen_string_literal: true

module MultipleVehicleRouting
  class Place
    attr_accessor :name, :coordinates, :capacity

    def initialize(options)
      @name        = options[:name]
      @coordinates = options[:coordinates]
      @capacity    = options[:capacity]
    end

    def ==(other)
      return true if equal?(other)
      return false unless other.instance_of?(self.class)

      (coordinates == other.coordinates) && (capacity == other.capacity) && (name == other.name)
    end

    def hash
      name.hash + coordinates.hash + capacity.hash
    end

    def distance(place)
      @distance = @coordinates.distance_from(place.coordinates)
    end
  end
end
