# frozen_string_literal: true

describe MultipleVehicleRouting::Route do
  let(:city_1)   { MultipleVehicleRouting::City.new(name: 'a', coordinates: MultipleVehicleRouting::Coordinates.new(0, 1), capacity: 5)     }
  let(:city_2)   { MultipleVehicleRouting::City.new(name: 'b', coordinates: MultipleVehicleRouting::Coordinates.new(0, 2), capacity: 6)     }
  let(:city_3)   { MultipleVehicleRouting::City.new(name: 'c', coordinates: MultipleVehicleRouting::Coordinates.new(0, 5), capacity: 5)     }
  let(:center_1) { MultipleVehicleRouting::Center.new(name: 'A', coordinates: MultipleVehicleRouting::Coordinates.new(0, 3), capacity: 5)   }
  let(:center_2) { MultipleVehicleRouting::Center.new(name: 'B', coordinates: MultipleVehicleRouting::Coordinates.new(0, 4), capacity: 6)   }

  describe 'is not valid when' do
    it 'begins with a city' do
      expect(described_class.new(places: MultipleVehicleRouting::Places.new(city_1, city_2))).not_to(be_valid)
    end

    it 'ends with a center' do
      expect(described_class.new(places: MultipleVehicleRouting::Places.new(center_1, city_1, center_2))).not_to(be_valid)
    end

    it 'a city is repeated' do
      expect(described_class.new(places: MultipleVehicleRouting::Places.new(center_1, city_1, center_2, city_1))).not_to(be_valid)
    end

    it 'a center is repeated' do
      expect(described_class.new(places: MultipleVehicleRouting::Places.new(center_1, city_1, center_1, city_2))).not_to(be_valid)
    end

    it 'two centers occur together' do
      expect(described_class.new(places: MultipleVehicleRouting::Places.new(center_1, center_2, city_2))).not_to(be_valid)
    end
  end

  describe 'is valid when' do
    it 'begins with a center, ends with a city and all centers have at least one intermediate city' do
      expect(described_class.new(places: MultipleVehicleRouting::Places.new(center_1, city_1, center_2, city_2))).to(be_valid)
      expect(described_class.new(places: MultipleVehicleRouting::Places.new(center_1, city_1))).to(be_valid)
    end
  end

  describe 'Trips' do
    it 'knows that a route contains has to a trip' do
      route = described_class.new(places: MultipleVehicleRouting::Places.new(center_1, city_1, center_2, city_2))
      expect(route).not_to(be_contains_trip(1))
    end

    it 'knows that a route contains a trip' do
      route = described_class.new(places: MultipleVehicleRouting::Places.new(center_1, city_1, center_2, city_2))
      expect(route).to(be_contains_trip(MultipleVehicleRouting::Trip.new(places: MultipleVehicleRouting::Places.new(center_1, city_1, center_1))))
      expect(route).to(be_contains_trip(MultipleVehicleRouting::Trip.new(places: MultipleVehicleRouting::Places.new(center_2, city_2, center_2))))
      expect(route).not_to(
        be_contains_trip(
          MultipleVehicleRouting::Trip.new(
            places: MultipleVehicleRouting::Places.new(center_1, city_2, center_1)
          )
        )
      )
    end

    it 'knows that the contained trips present in an array when the trips belong to the same route' do
      route = described_class.new(places: MultipleVehicleRouting::Places.new(center_1, city_1, center_2, city_2))
      expect(route).to(be_contains_trips(route.trips))
    end

    it 'knows that the contained trips present in an array when the trips belong to a different identical route' do
      route_1 = described_class.new(places: MultipleVehicleRouting::Places.new(center_1, city_1, center_2, city_2))
      route_2 = described_class.new(places: MultipleVehicleRouting::Places.new(center_1, city_1, center_2, city_2))
      expect(route_1).to(be_contains_trips(route_2.trips))
    end

    it 'knows that the contained trips present in an array has one trip is missing from the list' do
      route = described_class.new(places: MultipleVehicleRouting::Places.new(center_1, city_1, center_2, city_2))
      trips = [MultipleVehicleRouting::Trip.new(places: MultipleVehicleRouting::Places.new(center_1, city_1, center_1))]
      expect(route).not_to(be_contains_trips(trips))
    end

    it 'knows that the contained trips present in an array has one trip extra in the list' do
      route = described_class.new(places: MultipleVehicleRouting::Places.new(center_1, city_1, center_2, city_2))
      trips = [
        MultipleVehicleRouting::Trip.new(places: MultipleVehicleRouting::Places.new(center_1, city_1, center_1)),
        MultipleVehicleRouting::Trip.new(places: MultipleVehicleRouting::Places.new(center_2, city_2, center_2)),
        MultipleVehicleRouting::Trip.new(places: MultipleVehicleRouting::Places.new(center_1, city_2, center_1))
      ]
      expect(route).not_to(be_contains_trips(trips))
    end

    it 'knows that the contained trips present in an array has one trip different in the list' do
      route = described_class.new(places: MultipleVehicleRouting::Places.new(center_1, city_1, center_2, city_2))
      trips = [
        MultipleVehicleRouting::Trip.new(places: MultipleVehicleRouting::Places.new(center_1, city_1, center_1)),
        MultipleVehicleRouting::Trip.new(places: MultipleVehicleRouting::Places.new(center_2, city_1, center_2))
      ]
      expect(route).not_to(be_contains_trips(trips))
    end
  end

  describe 'to_s' do
    it 'serializes to a string representation' do
      expect(
        described_class.new(
          places: MultipleVehicleRouting::Places.new(center_1, city_1, center_2, city_2)
        ).to_s
      ).to(eq('(A -> a -> A)[5] (B -> b -> B)[6] => [2:8.00]'))
    end
  end

  describe 'equals' do
    it 'itself' do
      route = described_class.new(places: MultipleVehicleRouting::Places.new(center_1, city_1, center_2, city_2))
      expect(route).to(eq(route))
    end

    context 'with another route' do
      it 'is identical' do
        route_1 = described_class.new(places: MultipleVehicleRouting::Places.new(center_1, city_1, center_2, city_2))
        route_2 = described_class.new(places: MultipleVehicleRouting::Places.new(center_1, city_1, center_2, city_2))
        expect(route_1).to(eq(route_2))
      end
    end
  end

  describe "doesn't equal" do
    it 'nil' do
      route = described_class.new(places: MultipleVehicleRouting::Places.new(center_1, city_1, center_2, city_2))
      expect(route).not_to(be_nil)
    end

    it 'an object of another class' do
      route = described_class.new(places: MultipleVehicleRouting::Places.new(center_1, city_1, center_2, city_2))
      expect(route).not_to(eq('route'))
    end

    context 'with another route' do
      it 'has different number of trips' do
        route_1 = described_class.new(places: MultipleVehicleRouting::Places.new(center_1, city_1, center_2, city_2))
        route_2 = described_class.new(places: MultipleVehicleRouting::Places.new(center_1, city_1, city_2))
        expect(route_1).not_to(eq(route_2))
      end

      it 'has a different city present in one trip' do
        route_1 = described_class.new(places: MultipleVehicleRouting::Places.new(center_1, city_1, center_2, city_2))
        route_2 = described_class.new(places: MultipleVehicleRouting::Places.new(center_1, city_1, center_2, city_3))
        expect(route_1).not_to(eq(route_2))
      end
    end
  end

  describe 'Splitting into trips' do
    it 'splits a route into trips' do
      route = described_class.new(places: MultipleVehicleRouting::Places.new(center_1, city_1, center_2, city_2))
      trip_1 = MultipleVehicleRouting::Trip.new(places: MultipleVehicleRouting::Places.new(center_1, city_1, center_1))
      trip_2 = MultipleVehicleRouting::Trip.new(places: MultipleVehicleRouting::Places.new(center_2, city_2, center_2))

      trips = route.trips
      expect(trips).to(have(2).entries)
      expect(trips).to(eq([trip_1, trip_2]))
    end
  end

  describe 'Fitness' do
    it 'knows the total distance of the route' do
      expect(described_class.new(places: MultipleVehicleRouting::Places.new(center_1, city_1, city_2)).total_distance).to(eq(4))
      expect(described_class.new(places: MultipleVehicleRouting::Places.new(center_1, city_1, center_2, city_2)).total_distance).to(eq(8))
    end

    it 'knows the total overloads of the route' do
      places = MultipleVehicleRouting::Places.new(center_1, city_1, center_2, city_2)
      expect(described_class.new(places: places, permitted_load: 4).total_overloads).to(eq(2))
      expect(described_class.new(places: places, permitted_load: 5).total_overloads).to(eq(1))
      expect(described_class.new(places: places, permitted_load: 6).total_overloads).to(eq(0))
    end

    it 'knows the total overloads of the route and pick permitted loads from attributes' do
      route = described_class.new(places: MultipleVehicleRouting::Places.new(center_1, city_1, center_2, city_2), permitted_load: 5)
      expect(route.total_overloads).to(eq(1))
    end

    it 'knows that a fitter route has less overloads' do
      route_1 = described_class.new(places: MultipleVehicleRouting::Places.new(center_1, city_1, center_2, city_2), permitted_load: 5)
      route_2 = described_class.new(places: MultipleVehicleRouting::Places.new(center_1, city_1, center_2, city_2), permitted_load: 4)
      expect(route_1).to(be_fitter_than(route_2))
      expect(route_2).not_to(be_fitter_than(route_1))
    end

    it 'knows that a fitter route with same overloads has less total distance' do
      route_1 = described_class.new(places: MultipleVehicleRouting::Places.new(center_1, city_1, center_2, city_2), permitted_load: 5)
      route_2 = described_class.new(places: MultipleVehicleRouting::Places.new(center_1, city_1, city_2), permitted_load: 5)
      expect(route_1).not_to(be_fitter_than(route_2))
      expect(route_2).to(be_fitter_than(route_1))
    end
  end

  describe 'on mutation' do
    it 'forms a valid route in all cases' do
      route = described_class.new(places: MultipleVehicleRouting::Places.new(center_1, city_1, center_2, city_2, city_3))
      1.upto(1000) { expect(route.mutate!).to(be_valid) }
    end

    it 'forms combinations of routes allowing alteration in city and center positions when repeated sufficiently' do
      original_route = described_class.new(places: MultipleVehicleRouting::Places.new(center_1, city_1, center_2, city_2))
      mutated_route_1 = described_class.new(places: MultipleVehicleRouting::Places.new(center_1, city_2, center_2, city_1))
      mutated_route_2 = described_class.new(places: MultipleVehicleRouting::Places.new(center_2, city_1, center_1, city_2))
      mutated_route_3 = described_class.new(places: MultipleVehicleRouting::Places.new(center_2, city_2, center_1, city_1))
      serialized_possible_mutated_routes = [original_route, mutated_route_1, mutated_route_2, mutated_route_3].map(&:to_s)

      serialized_mutated_routes = 1.upto(1000).map { original_route.mutate!.to_s }
      serialized_mutated_routes.each { |route| expect(serialized_possible_mutated_routes).to(include(route)) }
    end
  end
end
