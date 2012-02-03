require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/place_distance_checks'
require File.dirname(__FILE__) + '/place_equivalence_checks'

describe Center do
  it "should have a name, coordinates and a capacity" do
    place = Center.new(:name => 'a', :x_coordinate => 1, :y_coordinate => 2, :capacity => 100)
    place.name.should == 'a'
    place.coordinates.x.should == 1
    place.coordinates.y.should == 2
    place.capacity.should == 100
  end
    
  it "should know that it is a center" do
    Center.new(:name => 'A', :x_coordinate => 0, :y_coordinate => 0).should be_center
  end
  
  it "should know that it is not a city" do
    Center.new(:name => 'a', :x_coordinate => 0, :y_coordinate => 0).should_not be_city
  end

  let(:klass) { Center }
  let(:other_klass) { City }

  it_should_behave_like "Place distance checks"

  it_should_behave_like "Place equivalence checks"
end
