# frozen_string_literal: true

shared_examples_for 'Place' do |klass, other_klass|
  context 'in test for equality' do
    it 'equals when they are identical' do
      place_1 = klass.new(name: 'a', coordinates: Coordinates.new(0, 0), capacity: 10)
      expect(place_1).to eq place_1
    end

    it 'is not equal to nil' do
      place_1 = klass.new(name: 'a', coordinates: Coordinates.new(0, 0), capacity: 10)
      expect(place_1).not_to eq nil
    end

    it 'is not equal to object of another class' do
      place_1 = klass.new(name: 'a', coordinates: Coordinates.new(0, 0), capacity: 10)
      place_2 = other_klass.new(name: 'a', coordinates: Coordinates.new(0, 0), capacity: 10)
      expect(place_1).not_to eq place_2
    end

    it 'is not equal when names are not equal' do
      place_1 = klass.new(name: 'a', coordinates: Coordinates.new(0, 0), capacity: 10)
      place_2 = klass.new(name: 'b', coordinates: Coordinates.new(0, 0), capacity: 10)
      expect(place_1).not_to eq place_2
    end

    it 'is not equal when x_coordinates are not equal' do
      place_1 = klass.new(name: 'a', coordinates: Coordinates.new(3, 4), capacity: 10)
      place_2 = klass.new(name: 'a', coordinates: Coordinates.new(4, 4), capacity: 10)
      expect(place_1).not_to eq place_2
    end

    it 'is not equal when y-coordinates are not equal' do
      place_1 = klass.new(name: 'a', coordinates: Coordinates.new(3, 4), capacity: 10)
      place_2 = klass.new(name: 'b', coordinates: Coordinates.new(3, 5), capacity: 10)
      expect(place_1).not_to eq place_2
    end

    it 'is not equal when names are not equal' do
      place_1 = klass.new(name: 'a', coordinates: Coordinates.new(0, 0), capacity: 10)
      place_2 = klass.new(name: 'b', coordinates: Coordinates.new(0, 0), capacity: 10)
      expect(place_1).not_to eq place_2
    end

    it 'is not equal when capacities are not equal' do
      place_1 = klass.new(name: 'a', coordinates: Coordinates.new(0, 1), capacity: 10)
      place_2 = klass.new(name: 'b', coordinates: Coordinates.new(0, 1), capacity: 11)
      expect(place_1).not_to eq place_2
    end

    it 'equals when all its attributes are equal' do
      place_1 = klass.new(name: 'a', coordinates: Coordinates.new(3, 4), capacity: 10)
      place_2 = klass.new(name: 'a', coordinates: Coordinates.new(3, 4), capacity: 10)
      expect(place_1).to eq place_2
    end

    it 'has same hash for equal objects' do
      place_1 = klass.new(name: 'a', coordinates: Coordinates.new(3, 4), capacity: 10)
      place_2 = klass.new(name: 'a', coordinates: Coordinates.new(3, 4), capacity: 10)
      expect(place_1.hash).to eq place_2.hash
    end
  end

  context 'when finding distance' do
    it 'knows its distance from another place' do
      place_1 = klass.new(name: 'a', coordinates: Coordinates.new(0, 0))
      place_2 = klass.new(name: 'b', coordinates: Coordinates.new(3, 4))
      expect(place_1.distance(place_2)).to eq 5.0
      expect(place_2.distance(place_1)).to eq 5.0
    end

    it 'knows its distance from place of another type' do
      place_1 = klass.new(name: 'a', coordinates: Coordinates.new(0, 0))
      place_2 = other_klass.new(name: 'b', coordinates: Coordinates.new(3, 4))
      expect(place_1.distance(place_2)).to eq 5.0
      expect(place_2.distance(place_1)).to eq 5.0
    end
  end
end
