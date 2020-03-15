require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/place_checks'

describe City do
  let(:coordinates) { Coordinates.new 1, 2 }
  let(:place) { City.new(:name => 'a', :coordinates => coordinates, :capacity => 100) }

  it "has a name, coordinates and a capacity" do
    expect(place.name).to eq 'a'
    expect(place.coordinates).to eq coordinates
    expect(place.capacity).to eq 100
  end

  it "knows that it is a city" do
    expect(place).to be_city
  end

  it "knows that it is not a center" do
    expect(place).to_not be_center
  end

  it_should_behave_like "Place", City, Center

  describe "on handle split for trips" do
    before :each do
      @center = Center.new(:coordinates => Coordinates.new(10, 5), :name => 'A')
      @places_list = [Places.new(@center), Places.new(@center)]
      place.handle_splits_for_trips @places_list
    end

    it "adds a city to the end place" do
      last_places = @places_list.last
      expect(last_places.places).to eq [@center, place]
    end

    it "doesn't create a new places" do
      expect(@places_list).to have(2).entries
    end

    it "doesn't modify earlier places" do
      expect(@places_list.first.places).to eq [@center]
    end
  end
end
