require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/place_checks'

describe Center do
  let(:coordinates) { Coordinates.new 1, 2 }
  let(:place) { Center.new(:name => 'A', :coordinates => coordinates, :capacity => 100) }

  it "has a name, coordinates and a capacity" do
    expect(place.name).to eq 'A'
    expect(place.coordinates).to eq coordinates
    expect(place.capacity).to eq 100
  end

  it "knows that it is a center" do
    expect(place).to be_center
  end

  it "knows that it is not a city" do
    expect(place).not_to be_city
  end

  it_should_behave_like "Place", Center, City

  describe "on handle split for trips" do
    before :each do
      @another_center = Center.new(:coordinates => Coordinates.new(10, 5), :name => 'O')
      @places_list = [Places.new(@another_center)]
      place.handle_splits_for_trips @places_list
    end

    it "adds a new places to the list of places" do
      expect(@places_list).to have(2).entries
    end

    it "add a new places containng the center to the end" do
      expect(@places_list.last.places).to eq [place]
    end

    it "doesn't modify earlier places" do
      expect(@places_list.first.places).to eq [@another_center]
    end
  end
end
