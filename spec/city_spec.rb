require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/place_checks'

describe City do
  let(:coordinates) { Coordinates.new 1, 2 }
  let(:place) { City.new(:name => 'A', :coordinates => coordinates, :capacity => 100) }

  it "should have a name, coordinates and a capacity" do
    place.name.should == 'A'
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
end
