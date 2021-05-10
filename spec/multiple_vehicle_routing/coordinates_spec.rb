# frozen_string_literal: true

module MultipleVehicleRouting
  describe Coordinates do
    it 'knows its x-coordinate' do
      expect(Coordinates.new(10, 5).x).to(eq(10))
    end

    it 'knows its y-coordinate' do
      expect(Coordinates.new(10, 5).y).to(eq(5))
    end

    describe 'equals' do
      it 'itself' do
        coordinates = Coordinates.new(2, 4)
        expect(coordinates).to(eq(coordinates))
      end

      it 'another coordinate with same x and y coordinates' do
        expect(Coordinates.new(2, 4)).to(eq(Coordinates.new(2, 4)))
      end
    end

    describe "doesn't equal" do
      it 'coordinate with a different x' do
        expect(Coordinates.new(2, 4)).not_to(eq(Coordinates.new(1, 4)))
      end

      it 'coordinate with a different y' do
        expect(Coordinates.new(2, 4)).not_to(eq(Coordinates.new(2, -4)))
      end

      it 'nil' do
        expect(Coordinates.new(2, 4)).not_to(eq(nil))
      end

      it 'object not an instance of Coordinates' do
        expect(Coordinates.new(2, 4)).not_to(eq([]))
      end
    end

    it 'knows it distance from another coordinate' do
      expect(Coordinates.new(2, 3).distance_from(Coordinates.new(5, 7))).to(eq(5))
    end

    describe 'hash' do
      it 'is equal when identical' do
        coordinates_1 = Coordinates.new(1, 3)
        coordinates_2 = Coordinates.new(1, 3)
        expect(coordinates_1.hash).to(eq(coordinates_2.hash))
      end
    end
  end
end