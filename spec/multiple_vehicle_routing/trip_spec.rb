# frozen_string_literal: true

module MultipleVehicleRouting
  describe Trip do
    let(:city_1) { City.new(name: 'a', coordinates: Coordinates.new(0, 1), capacity: 5) }
    let(:city_2) { City.new(name: 'b', coordinates: Coordinates.new(0, 2), capacity: 6) }
    let(:city_3) { City.new(name: 'c', coordinates: Coordinates.new(0, 8), capacity: 6) }
    let(:city_4) { City.new(name: 'd', coordinates: Coordinates.new(0, 6), capacity: 6) }
    let(:center_1) { Center.new(name: 'A', coordinates: Coordinates.new(0, 3), capacity: 5) }
    let(:center_2) { Center.new(name: 'B', coordinates: Coordinates.new(0, 4), capacity: 6) }

    describe 'center' do
      it 'is the first place' do
        places = Places.new(center_1, city_1, city_2, center_1)
        expect(Trip.new(places: places).center).to(eq(center_1))
      end
    end

    describe 'cities' do
      it 'are the intermediate places' do
        places = Places.new(center_1, city_1, city_2, center_1)
        expect(Trip.new(places: places).cities).to(eq(Places.new(city_1, city_2)))
      end
    end

    describe 'to_s' do
      it 'serializes to a string representaion' do
        places = Places.new(center_1, city_1, city_2, center_1)
        expect(Trip.new(places: places).to_s).to(eq('(A -> a -> b -> A)[11]'))
      end
    end

    describe 'is not valid when it' do
      it 'begins with city' do
        expect(Trip.new(places: Places.new(city_1, center_1))).not_to(be_valid)
      end

      it 'ends with city' do
        expect(Trip.new(places: Places.new(center_1, city_1))).not_to(be_valid)
      end

      it "doesn't begin and end with the same center" do
        expect(Trip.new(places: Places.new(center_1, center_2))).not_to(be_valid)
      end

      it 'begins and ends with the same city' do
        expect(Trip.new(places: Places.new(city_1, city_1))).not_to(be_valid)
      end

      it 'has more than one center' do
        expect(Trip.new(places: Places.new(center_1, city_1, center_2, city_2, center_1))).not_to(be_valid)
      end

      it 'any city is repeated' do
        expect(Trip.new(places: Places.new(center_1, city_1, city_1, center_1))).not_to(be_valid)
      end
    end

    describe 'is valid when it' do
      it 'begins and end with same center with unique intermediate cities' do
        expect(Trip.new(places: Places.new(center_1, city_1, city_2, center_1))).to(be_valid)
      end
    end

    describe "doesn't equal" do
      let(:places) { Places.new(center_1, city_1, city_2, city_3, center_1) }
      let(:trip) { Trip.new(places: places) }

      it 'nil' do
        expect(trip).not_to(eq(nil))
      end

      it 'object of another class' do
        expect(trip).to_not(eq(places))
      end

      context 'another trip with' do
        it 'different number of places' do
          expect(trip).not_to(eq(Trip.new(places: Places.new(center_1, city_1, city_2, center_1))))
          expect(trip).not_to(eq(Trip.new(places: Places.new(center_1, city_1, city_2, city_3, city_4, center_1))))
        end

        it 'different places' do
          expect(trip).not_to(eq(Trip.new(places: Places.new(center_1, city_1, city_2, city_4, center_1))))
          expect(trip).not_to(eq(Trip.new(places: Places.new(center_2, city_1, city_2, city_3, center_2))))
        end

        it 'different order of places' do
          another_trip = Trip.new(places: Places.new(center_1, city_1, city_3, city_4, center_1))
          expect(trip).not_to(eq(another_trip))
        end
      end
    end

    describe 'equals' do
      let(:trip) { Trip.new(places: Places.new(center_1, city_1, city_2, city_3, center_1)) }

      it 'itself' do
        expect(trip).to(eq(trip))
      end

      context 'another trip with' do
        it 'same place order' do
          expect(trip).to(eq(Trip.new(places: Places.new(center_1, city_1, city_2, city_3, center_1))))
        end

        it 'reverse place order' do
          expect(trip).to(eq(Trip.new(places: Places.new(center_1, city_3, city_2, city_1, center_1))))
        end
      end
    end

    describe '<<' do
      it 'builds a trip from centers and cities' do
        trip = Trip.new
        trip << center_1
        trip << city_1
        trip << center_1
        expect(trip).to(eq(Trip.new(places: Places.new(center_1, city_1, center_1))))
      end
    end

    describe 'round trip distance' do
      it 'is the round-trip distance for the places' do
        expect(Trip.new(places: Places.new(center_1, city_1, center_1)).round_trip_distance).to(eq(4))
      end
    end

    describe 'total lod' do
      it 'is the sum of the capacity for all cities' do
        expect(Trip.new(places: Places.new(center_1, city_1, city_2, center_1), permitted_load: 5).total_load).to(eq(11))
      end
    end

    describe 'is overloaded' do
      it 'when all sum of capacity for all cities exceeds the permitted load' do
        expect(Trip.new(places: Places.new(center_1, city_2, center_1), permitted_load: 5)).to(be_overloaded)
      end
    end

    describe 'is not overloaded' do
      it 'when all sum of capacity for all cities equals the permitted load' do
        expect(Trip.new(places: Places.new(center_1, city_1, center_1), permitted_load: 5)).not_to(be_overloaded)
      end

      it 'when all sum of capacity for all cities is less than the permitted load' do
        expect(Trip.new(places: Places.new(center_1, city_1, city_2, center_1), permitted_load: 12)).not_to(be_overloaded)
      end
    end
  end
end
