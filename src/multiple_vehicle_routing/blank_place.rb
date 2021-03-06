# frozen_string_literal: true

module MultipleVehicleRouting
  class BlankPlace
    def city?
      false
    end

    def center?
      false
    end

    def ==(other)
      other.is_a?(BlankPlace)
    end

    def hash
      object_id
    end
  end
end
