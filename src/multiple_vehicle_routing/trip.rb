# frozen_string_literal: true

require 'forwardable'

module MultipleVehicleRouting
  class Trip
    attr_reader :places, :permitted_load

    extend Forwardable

    def initialize(options = {})
      @places         = options[:places]         || Places.new
      @permitted_load = options[:permitted_load] || 0
    end

    PLACES_VALIDATIONS = %i[
      begins_with_center?
      has_same_center_at_extremes?
      has_no_intermediate_center?
      has_unique_cities?
    ].freeze

    def valid?
      PLACES_VALIDATIONS.all? { |validation| places.send validation }
    end

    def ==(other)
      return true if equal? other
      return false unless other.instance_of? self.class

      (places == other.places) || (places.reverse == other.places)
    end

    def_delegators :places, :<<, :hash, :round_trip_distance

    def to_s
      "#{places}[#{total_load}]"
    end

    def center
      places.first_place
    end

    def cities
      places.intermediates
    end

    def total_load
      cities.places.map(&:capacity).reduce(0, &:+)
    end

    def overloaded?
      total_load > permitted_load
    end
  end
end
