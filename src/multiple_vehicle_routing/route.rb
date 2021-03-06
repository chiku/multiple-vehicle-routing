# frozen_string_literal: true

module MultipleVehicleRouting
  class Route
    attr_reader :places, :trips, :permitted_load

    PLACES_VALIDATIONS = %i[begins_with_center? ends_with_city? has_unique_places? has_no_consecutive_center?].freeze
    private_constant :PLACES_VALIDATIONS

    def initialize(places: Places.new, permitted_load: 0)
      @places         = places
      @permitted_load = permitted_load
      split_into_trips
    end

    def valid?
      PLACES_VALIDATIONS.all? { |validation| places.public_send(validation) }
    end

    def ==(other)
      return true if equal?(other)
      return false unless other.instance_of?(self.class)

      contains_trips?(other.trips)
    end

    def total_distance
      trips.map(&:round_trip_distance).reduce(0, &:+)
    end

    def total_overloads
      trips.count(&:overloaded?)
    end

    def fitter_than?(other_route)
      total_overloads == other_route.total_overloads ? (total_distance < other_route.total_distance) : (total_overloads < other_route.total_overloads)
    end

    def contains_trips?(trip_list)
      (trip_list.size == trips.size) && trip_list.all? { |trip| contains_trip?(trip) }
    end

    def contains_trip?(trip)
      trips.include?(trip)
    end

    def to_s
      "#{trips.map(&:to_s).join(' ')} => [#{total_overloads}:#{format('%<total_distance>0.2f', total_distance: total_distance)}]"
    end

    def mutate!
      places.interchange_positions_on_equivalence!(rand(places.size), rand(places.size))
      split_into_trips
      self
    end

    def split_into_trips
      @trips = places.split_by_leading_center.map { |places| Trip.new(places: places.replicate_first_place_to_end, permitted_load: permitted_load) }
    end
    private :split_into_trips
  end
end
