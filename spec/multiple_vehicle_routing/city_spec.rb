# frozen_string_literal: true

describe MultipleVehicleRouting::City do
  let(:coordinates) { MultipleVehicleRouting::Coordinates.new(1, 2)                           }
  let(:place)       { described_class.new(name: 'a', coordinates: coordinates, capacity: 100) }

  it 'has a name' do
    expect(place.name).to(eq('a'))
  end

  it 'has coordinates' do
    expect(place.coordinates).to(eq(coordinates))
  end

  it 'has a capacity' do
    expect(place.capacity).to(eq(100))
  end

  it 'knows that it is a city' do
    expect(place).to(be_city)
  end

  it 'knows that it is not a center' do
    expect(place).not_to(be_center)
  end

  it_behaves_like 'Place', described_class, MultipleVehicleRouting::Center

  describe 'on handle split for trips' do
    let(:center) { MultipleVehicleRouting::Center.new(coordinates: MultipleVehicleRouting::Coordinates.new(10, 5), name: 'A') }
    let(:places_list) { [MultipleVehicleRouting::Places.new(center), MultipleVehicleRouting::Places.new(center)] }

    it 'adds a city to the end place' do
      place.handle_splits_for_trips(places_list)
      last_places = places_list.last
      expect(last_places.places).to(eq([center, place]))
    end

    it "doesn't create a new places" do
      place.handle_splits_for_trips(places_list)
      expect(places_list).to(have(2).entries)
    end

    it "doesn't modify earlier places" do
      place.handle_splits_for_trips(places_list)
      expect(places_list.first.places).to(eq([center]))
    end
  end
end
