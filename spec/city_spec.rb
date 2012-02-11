require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/place_checks'

describe City do
  let(:coordinates) { Coordinates.new 1, 2 }
  let(:place) { City.new(:name => 'a', :coordinates => coordinates, :capacity => 100) }

  it "should have a name, coordinates and a capacity" do
    place.name.should == 'a'
    place.coordinates.should == coordinates
    place.capacity.should == 100
  end

  it "should know that it is a city" do
    place.should be_city
  end

  it "should know that it is not a center" do
    place.should_not be_center
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
      last_places.places.should == [@center, place]
    end

    it "doesn't create a new places" do
      @places_list.should have(2).things
    end

    it "doesn't modify earlier places" do
      @places_list.first.places.should == [@center]
    end
  end
end
