require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/place_checks'

describe Center do
  let(:coordinates) { Coordinates.new 1, 2 }
  let(:place) { Center.new(:name => 'A', :coordinates => coordinates, :capacity => 100) }

  it "has a name, coordinates and a capacity" do
    place.name.should == 'A'
    place.coordinates.should == coordinates
    place.capacity.should == 100
  end

  it "knows that it is a center" do
    place.should be_center
  end

  it "knows that it is not a city" do
    place.should_not be_city
  end

  it_should_behave_like "Place", Center, City

  describe "on handle split for trips" do
    before :each do
      @another_center = Center.new(:coordinates => Coordinates.new(10, 5), :name => 'O')
      @places_list = [Places.new(@another_center)]
      place.handle_splits_for_trips @places_list
    end

    it "adds a new places to the list of places" do
      @places_list.should have(2).thing
    end

    it "add a new places containng the center to the end" do
      @places_list.last.places.should == [place]
    end

    it "doesn't modify earlier places" do
      @places_list.first.places.should == [@another_center]
    end
  end
end
