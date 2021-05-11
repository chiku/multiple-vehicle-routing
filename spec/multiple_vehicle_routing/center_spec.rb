# frozen_string_literal: true

describe MultipleVehicleRouting::Center do
  let(:coordinates) { MultipleVehicleRouting::Coordinates.new(1, 2)                           }
  let(:place)       { described_class.new(name: 'A', coordinates: coordinates, capacity: 100) }

  it 'has a name' do
    expect(place.name).to(eq('A'))
  end

  it 'has coordinates' do
    expect(place.coordinates).to(eq(coordinates))
  end

  it 'has a capacity' do
    expect(place.capacity).to(eq(100))
  end

  it 'knows that it is a center' do
    expect(place).to(be_center)
  end

  it 'knows that it is not a city' do
    expect(place).not_to(be_city)
  end

  it_behaves_like 'Place', described_class, MultipleVehicleRouting::City

  describe 'on handle split for trips' do
    let(:another_center) { described_class.new(coordinates: MultipleVehicleRouting::Coordinates.new(10, 5), name: 'O') }
    let(:places_list) { [MultipleVehicleRouting::Places.new(another_center)] }

    it 'adds a new places to the list of places' do
      place.handle_splits_for_trips(places_list)
      expect(places_list).to(have(2).entries)
    end

    it 'add a new places containng the center to the end' do
      place.handle_splits_for_trips(places_list)
      expect(places_list.last.places).to(eq([place]))
    end

    it "doesn't modify earlier places" do
      place.handle_splits_for_trips(places_list)
      expect(places_list.first.places).to(eq([another_center]))
    end
  end
end
