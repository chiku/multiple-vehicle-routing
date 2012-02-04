require File.dirname(__FILE__) + '/spec_helper'

describe Trip do
  let(:city_1) { City.new(:name => 'a', :x_coordinate => 0, :y_coordinate => 1, :capacity => 5) }
  let(:city_2) { City.new(:name => 'b', :x_coordinate => 0, :y_coordinate => 2, :capacity => 6) }
  let(:city_3) { City.new(:name => 'c', :x_coordinate => 0, :y_coordinate => 8, :capacity => 6) }
  let(:city_4) { City.new(:name => 'd', :x_coordinate => 0, :y_coordinate => 6, :capacity => 6) }
  let(:center_1) { Center.new(:name => 'A', :x_coordinate => 0, :y_coordinate => 3, :capacity => 5) }
  let(:center_2) { Center.new(:name => 'B', :x_coordinate => 0, :y_coordinate => 4, :capacity => 6) }

  context "center" do
    it "is the first place" do
      places = Places.new center_1, city_1, city_2, center_1
      Trip.new(:places => places).center.should == center_1
    end
  end

  context "cities" do
    it "are the intermediate places" do
      places = Places.new center_1, city_1, city_2, center_1
      Trip.new(:places => places).cities.should == [city_1, city_2]
    end
  end

  context "to_s" do
    it "serializes to string representaion of places" do
      places = Places.new center_1, city_1, city_2, center_1
      Trip.new(:places => places).to_s.should == places.to_s
    end
  end

  context "is not valid when it" do
    it "begins with city" do
      Trip.new(:places => Places.new(city_1, center_1)).should_not be_valid
    end

    it "ends with city" do
      Trip.new(:places => Places.new(center_1, city_1)).should_not be_valid
    end
    
    it "doesn't begin and end with the same center" do
      Trip.new(:places => Places.new(center_1, center_2)).should_not be_valid
    end
    
    it "begins and ends with the same city" do
      Trip.new(:places => Places.new(city_1, city_1)).should_not be_valid
    end
    
    it "has more than one center" do
      Trip.new(:places => Places.new(center_1, city_1, center_2, city_2, center_1)).should_not be_valid
    end
    
    it "any city is repeated" do
      Trip.new(:places => Places.new(center_1, city_1, city_1, center_1)).should_not be_valid
    end
  end

  context "is valid when it" do
    it "begins and end with same center with unique intermediate cities" do
      Trip.new(:places => Places.new(center_1, city_1, city_2, center_1)).should be_valid
    end
  end

  context "doesn't equal" do
    let(:places) { Places.new(center_1, city_1, city_2, city_3, center_1) }
    let(:trip) { Trip.new :places => places }

    it "nil" do
      trip.should_not == nil
    end

    it "places" do
      trip.should_not == places
    end

    it "another trip with different number of places" do
      trip.should_not == Trip.new(:places => Places.new(center_1, city_1, city_2, center_1))
      trip.should_not == Trip.new(:places => Places.new(center_1, city_1, city_2, city_3, city_4, center_1))
    end

    it "another trip with different places" do
      trip.should_not == Trip.new(:places => Places.new(center_1, city_1, city_2, city_4, center_1))
      trip.should_not == Trip.new(:places => Places.new(center_2, city_1, city_2, city_3, center_2))
    end

    it "another trip with different order of places" do
      another_trip = Trip.new(:places => Places.new(center_1, city_1, city_3, city_4, center_1))
      trip.should_not == another_trip
    end
  end

  context "equals" do
    let(:trip) { Trip.new :places => Places.new(center_1, city_1, city_2, city_3, center_1) }

    it "itself" do
      trip.should == trip
    end

    it "trip with same place order" do
      trip.should == Trip.new(:places => Places.new(center_1, city_1, city_2, city_3, center_1))
    end

    it "trip with reverse place order" do
      trip.should == Trip.new(:places => Places.new(center_1, city_3, city_2, city_1, center_1))
    end
  end

  context "add" do
    it "builds a trip from centers and cities" do
      trip = Trip.new
      trip.add center_1
      trip.add city_1
      trip.add center_1
      trip.should == Trip.new(center_1, city_1, center_1)
    end
  end

  context "total distance" do
    it "is the round-trip distance for the places" do
      Trip.new(:places => Places.new(center_1, city_1, center_1)).total_distance.should == 4
    end
  end

  context "is overloaded" do
    it "when all sum of capacity for all cities exceeds the permitted load" do
      Trip.new(:places => Places.new(center_1, city_2, center_1), :permitted_load => 5).should be_overloaded
    end
  end

  context "is not overloaded" do
    it "when all sum of capacity for all cities equals the permitted load" do
      Trip.new(:places => Places.new(center_1, city_1, center_1), :permitted_load => 5).should_not be_overloaded
    end

    it "when all sum of capacity for all cities is less than the permitted load" do
      Trip.new(:places => Places.new(center_1, city_1, city_2, center_1), :permitted_load => 12).should_not be_overloaded
    end
  end

  context "THIS SPEC SHOULD BE DELETED" do
    it "should know the total overloads of the route and pick permitted loads from attributes" do
      trip = Trip.new(center_1, city_1, center_1)
      trip.permitted_load = 5
      trip.overloaded?.should be_false
    end
  end
end
