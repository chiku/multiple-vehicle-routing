require 'rspec'
require File.dirname(__FILE__) + '/../city'
require File.dirname(__FILE__) + '/../center'
require File.dirname(__FILE__) + '/place_distance_checks'
require File.dirname(__FILE__) + '/place_equivalence_checks'

describe City do
  before :each do
    @klass = City
    @other_klass = Center
  end
  
  it "should have a name, an x-coordinate, a y-coordinate and a capacity" do
    place = City.new(:name => 'a', :x_coordinate => 1, :y_coordinate => 2, :capacity => 100)
    place.name.should == 'a'
    place.x_coordinate.should == 1
    place.y_coordinate.should == 2
    place.capacity.should == 100
  end
  
  it "should know that it is a city" do
    City.new(:name => 'a', :x_coordinate => 0, :y_coordinate => 0).should be_city
  end
  
  it "should know that it is not a center" do
    City.new(:name => 'a', :x_coordinate => 0, :y_coordinate => 0).should_not be_center
  end
  
  it_should_behave_like "Place distance checks"
  
  it_should_behave_like "Place equivalence checks"
end
