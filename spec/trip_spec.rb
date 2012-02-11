require File.dirname(__FILE__) + '/spec_helper'

describe Trip do
  let(:city_1) { City.new(:name => 'a', :coordinates => Coordinates.new(0, 1), :capacity => 5) }
  let(:city_2) { City.new(:name => 'b', :coordinates => Coordinates.new(0, 2), :capacity => 6) }
  let(:city_3) { City.new(:name => 'c', :coordinates => Coordinates.new(0, 8), :capacity => 6) }
  let(:city_4) { City.new(:name => 'd', :coordinates => Coordinates.new(0, 6), :capacity => 6) }
  let(:center_1) { Center.new(:name => 'A', :coordinates => Coordinates.new(0, 3), :capacity => 5) }
  let(:center_2) { Center.new(:name => 'B', :coordinates => Coordinates.new(0, 4), :capacity => 6) }

  describe "center" do
    it "is the first place" do
      places = Places.new center_1, city_1, city_2, center_1
      Trip.new(:places => places).center.should == center_1
    end
  end

  describe "cities" do
    it "are the intermediate places" do
      places = Places.new center_1, city_1, city_2, center_1
      Trip.new(:places => places).cities.should == Places.new(city_1, city_2)
    end
  end

  describe "to_s" do
    it "serializes to a string representaion" do
      places = Places.new center_1, city_1, city_2, center_1
      Trip.new(:places => places).to_s.should == "(A -> a -> b -> A)[11]"
    end
  end

  describe "is not valid when it" do
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

  describe "is valid when it" do
    it "begins and end with same center with unique intermediate cities" do
      Trip.new(:places => Places.new(center_1, city_1, city_2, center_1)).should be_valid
    end
  end

  describe "doesn't equal" do
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

  describe "equals" do
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

  describe "<<" do
    it "builds a trip from centers and cities" do
      trip = Trip.new
      trip << center_1
      trip << city_1
      trip << center_1
      trip.should == Trip.new(:places => Places.new(center_1, city_1, center_1))
    end
  end

  describe "round trip distance" do
    it "is the round-trip distance for the places" do
      Trip.new(:places => Places.new(center_1, city_1, center_1)).round_trip_distance.should == 4
    end
  end

  describe "total lod" do
    it "is the sum of the capacity for all cities" do
      Trip.new(:places => Places.new(center_1, city_1, city_2, center_1), :permitted_load => 5).total_load.should == 11
    end
  end

  describe "is overloaded" do
    it "when all sum of capacity for all cities exceeds the permitted load" do
      Trip.new(:places => Places.new(center_1, city_2, center_1), :permitted_load => 5).should be_overloaded
    end
  end

  describe "is not overloaded" do
    it "when all sum of capacity for all cities equals the permitted load" do
      Trip.new(:places => Places.new(center_1, city_1, center_1), :permitted_load => 5).should_not be_overloaded
    end

    it "when all sum of capacity for all cities is less than the permitted load" do
      Trip.new(:places => Places.new(center_1, city_1, city_2, center_1), :permitted_load => 12).should_not be_overloaded
    end
  end
end
