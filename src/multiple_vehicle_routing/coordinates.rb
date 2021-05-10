# frozen_string_literal: true

module MultipleVehicleRouting
  class Coordinates
    attr_reader :x, :y

    def initialize(x, y)
      @x = x
      @y = y
    end

    def ==(other)
      return true if other.equal?(self)
      return false unless other.instance_of?(Coordinates)

      (other.x == x) && (other.y == y)
    end

    def hash
      x + y
    end

    def distance_from(other)
      x_diff = (x - other.x)
      y_diff = (y - other.y)
      Math.sqrt(x_diff * x_diff + y_diff * y_diff)
    end
  end
end
