require File.dirname(__FILE__) + '/spec_helper'

describe Trip do
  before :all do
    @city_1 = City.new(:name => 'a', :x_coordinate => 0, :y_coordinate => 1, :capacity => 5)
    @city_2 = City.new(:name => 'b', :x_coordinate => 0, :y_coordinate => 2, :capacity => 6)
    @center_1 = Center.new(:name => 'A', :x_coordinate => 0, :y_coordinate => 3, :capacity => 5)
    @center_2 = Center.new(:name => 'B', :x_coordinate => 0, :y_coordinate => 4, :capacity => 6)
  end
  
  describe "Accessor" do
    it "should know it center" do
      Trip.new(@center_1, @city_1, @city_2, @center_1).center.should == @center_1
    end
    
    it "should know its cities" do
      Trip.new(@center_1, @city_1, @city_2, @center_1).cities.should == [@city_1, @city_2]
    end
  end
  
  describe "Serialization" do
    it "should be serialize to string" do
      Trip.new(@center_1, @city_1, @city_2, @center_1).to_s.should == "(A -> a -> b -> A)"
    end
  end

  describe "Validity" do
    it "should not be valid if it begins with city" do
      Trip.new(@city_1, @center_1).should_not be_valid
    end

    it "should not be valid if it ends with city" do
      Trip.new(@center_1, @city_1).should_not be_valid
    end
    
    it "should not be valid if it does not begin and end with the same center" do
      Trip.new(@center_1, @center_2).should_not be_valid
    end
    
    it "should not be valid if it begins and ends with the same city" do
      Trip.new(@city_1, @city_1).should_not be_valid
    end
    
    it "should not be valid if it has more than one center" do
      Trip.new(@center_1, @city_1, @center_2, @city_2, @center_1).should_not be_valid
    end
    
    it "should not be valid if any city is repeated" do
      Trip.new(@center_1, @city_1, @city_1, @center_1).should_not be_valid
    end
    
    it "should be valid for a proper trip" do
      Trip.new(@center_1, @city_1, @city_2, @center_1).should be_valid      
   end
  end
  
  describe "Equality" do
    before :all do
      @city_1 = City.new(:name => 'a', :x_coordinate => 0, :y_coordinate => 1)
      @city_2 = City.new(:name => 'b', :x_coordinate => 0, :y_coordinate => 2)
      @center_1 = Center.new(:name => 'A', :x_coordinate => 0, :y_coordinate => 3)
      @center_2 = Center.new(:name => 'B', :x_coordinate => 0, :y_coordinate => 4)
    end
    
    it "should be equal when they are identical" do
      trip_1 = Trip.new(@center_1, @city_1, @center_1)
      (trip_1.equal?(trip_1)).should be_true
      (trip_1 == trip_1).should be_true
    end

    it "should not be equal to nil" do
      trip_1 = Trip.new(@center_1, @city_1, @center_1)
      (trip_1.equal?(nil)).should be_false
      (trip_1 == nil).should be_false
    end

    it "should not be equal to object of another class" do
      trip_1 = Trip.new(@center_1, @city_1, @center_1)
      (trip_1.equal?('trip_2')).should be_false
      (trip_1 == 'trip_2').should be_false
    end

    it "should be not equal when trip length are not equal" do
      trip_1 = Trip.new(@center_1, @city_1, @center_1)
      trip_2 = Trip.new(@center_1, @city_1, @city_2, @center_1)
      (trip_1.equal?(trip_2)).should be_false
      (trip_1 == trip_2).should be_false
    end

    it "should be not equal when the center is not equal" do
      trip_1 = Trip.new(@center_1, @city_1, @center_1)
      trip_2 = Trip.new(@center_2, @city_1, @center_2)
      (trip_1.equal?(trip_2)).should be_false
      (trip_1 == trip_2).should be_false
    end

    it "should be not equal when one city is not equal" do
      trip_1 = Trip.new(@center_1, @city_1, @center_1)
      trip_2 = Trip.new(@center_1, @city_2, @center_1)
      (trip_1.equal?(trip_2)).should be_false
      (trip_1 == trip_2).should be_false
    end

    it "should be not equal when number of cities is not equal" do
      trip_1 = Trip.new(@center_1, @city_1, @center_1)
      trip_2 = Trip.new(@center_1, @city_1, @city_2, @center_1)
      (trip_1.equal?(trip_2)).should be_false
      (trip_1 == trip_2).should be_false
    end

    it "should be equal when all its places are equal and in same position" do
      trip_1 = Trip.new(@center_1, @city_1, @city_2, @center_1)
      trip_2 = Trip.new(@center_1, @city_1, @city_2, @center_1)
      (trip_1.equal?(trip_2)).should be_true
      (trip_1 == trip_2).should be_true
    end

    it "should be equal when all its places are equal and in reverse position" do
      trip_1 = Trip.new(@center_1, @city_1, @city_2, @center_1)
      trip_2 = Trip.new(@center_1, @city_2, @city_1, @center_1)
      (trip_1.equal?(trip_2)).should be_true
      (trip_1 == trip_2).should be_true
    end
    
    it "should be have same hash for equal objects" do
      trip_1 = Trip.new(@center_1, @city_1, @center_1)
      trip_2 = Trip.new(@center_1, @city_1, @center_1)
      (trip_1.hash == trip_2.hash).should be_true
    end
  end
  
  describe "Building" do
    it "should be buildable from centers and cities" do
      trip = Trip.new 
      trip.add(@center_1)
      trip.add(@city_1)
      trip.should be_equal(Trip.new(@center_1, @city_1))
    end
  end
  
  describe "Fitness" do
    it "should know the total distance covered in the trip" do
      Trip.new(@center_1, @city_1, @center_1).total_distance.should == 4
      Trip.new(@center_1, @city_1, @city_2, @center_1).total_distance.should == 4
    end

    it "should know if the trip is overloaded" do
      Trip.new(@center_1, @city_1, @city_2, @center_1).overloaded?(12).should be_false
      Trip.new(@center_1, @city_1, @center_1).overloaded?(5).should be_false
      Trip.new(@center_1, @city_2, @center_1).overloaded?(5).should be_true
    end
    
    it "should know the total overloads of the route and pick permitted loads from attributes" do
      trip = Trip.new(@center_1, @city_1, @center_1)
      trip.permitted_load = 5
      trip.overloaded?.should be_false
    end
  end
end
