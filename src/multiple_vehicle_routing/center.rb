# frozen_string_literal: true

module MultipleVehicleRouting
  class Center < Place
    def city?
      false
    end

    def center?
      true
    end

    def handle_splits_for_trips(splits)
      splits << Places.new(self)
    end
  end
end
