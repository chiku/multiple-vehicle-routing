require File.dirname(__FILE__) + '/spec_helper'

describe Route do
  let(:city_1) { City.new(:name => 'a', :coordinates => Coordinates.new(0, 1), :capacity => 5) }
  let(:city_2) { City.new(:name => 'b', :coordinates => Coordinates.new(0, 2), :capacity => 6) }
  let(:city_3) { City.new(:name => 'c', :coordinates => Coordinates.new(0, 5), :capacity => 5) }
  let(:center_1) { Center.new(:name => 'A', :coordinates => Coordinates.new(0, 3), :capacity => 5) }
  let(:center_2) { Center.new(:name => 'B', :coordinates => Coordinates.new(0, 4), :capacity => 6) }

  describe "Validity" do
    it "should not be valid if it begins with a city" do
      Route.new(:places => Places.new(city_1, city_2)).should_not be_valid
    end

    it "should not be valid if it ends with a center" do
      Route.new(:places => Places.new(center_1, city_1, center_2)).should_not be_valid
    end

    it "should not be valid if a city is repeated" do
      Route.new(:places => Places.new(center_1, city_1, center_2, city_1)).should_not be_valid
   end

    it "should not be valid if a center is repeated" do
      Route.new(:places => Places.new(center_1, city_1, center_1, city_2)).should_not be_valid
   end

    it "should not be valid if two centers occur together" do
      Route.new(:places => Places.new(center_1, center_2, city_2)).should_not be_valid
   end

    it "should be valid for a proper route" do
      Route.new(:places => Places.new(center_1, city_1, center_2, city_2)).should be_valid
      Route.new(:places => Places.new(center_1, city_1)).should be_valid
   end
  end

  describe "Trips" do
    it "should know that a route contains has to a trip" do
      route = Route.new(:places => Places.new(center_1, city_1, center_2, city_2))
      route.contains_trip?(1).should be_false
    end

    it "should know that a route contains a trip" do
      route = Route.new(:places => Places.new(center_1, city_1, center_2, city_2))
      route.contains_trip?(Trip.new(:places => Places.new(center_1, city_1, center_1))).should be_true
      route.contains_trip?(Trip.new(:places => Places.new(center_2, city_2, center_2))).should be_true
      route.contains_trip?(Trip.new(:places => Places.new(center_1, city_2, center_1))).should be_false
    end

    it "should know that the contained trips present in an array when the trips belong to the same route" do
      route = Route.new(:places => Places.new(center_1, city_1, center_2, city_2))
      route.contains_trips?(route.trips).should be_true
    end

    it "should know that the contained trips present in an array when the trips belong to a different identical route" do
      route_1 = Route.new(:places => Places.new(center_1, city_1, center_2, city_2))
      route_2 = Route.new(:places => Places.new(center_1, city_1, center_2, city_2))
      route_1.contains_trips?(route_2.trips).should be_true
    end

    it "should know that the contained trips present in an array has one trip is missing from the list" do
      route = Route.new(:places => Places.new(center_1, city_1, center_2, city_2))
      trips = [Trip.new(:places => Places.new(center_1, city_1, center_1))]
      route.contains_trips?(trips).should be_false
    end

    it "should know that the contained trips present in an array has one trip extra in the list" do
      route = Route.new(:places => Places.new(center_1, city_1, center_2, city_2))
      trips = [
        Trip.new(:places => Places.new(center_1, city_1, center_1)),
        Trip.new(:places => Places.new(center_2, city_2, center_2)),
        Trip.new(:places => Places.new(center_1, city_2, center_1))
      ]
      route.contains_trips?(trips).should be_false
    end

    it "should know that the contained trips present in an array has one trip different in the list" do
      route = Route.new(:places => Places.new(center_1, city_1, center_2, city_2))
      trips = [
        Trip.new(:places => Places.new(center_1, city_1, center_1)),
        Trip.new(:places => Places.new(center_2, city_1, center_2))
      ]
      route.contains_trips?(trips).should be_false
    end
  end

  describe "Serialization" do
    it "should be serialize to string" do
      Route.new(:places => Places.new(center_1, city_1, center_2, city_2)).to_s.should == "(A -> a -> A)[5] (B -> b -> B)[6] => [2:8.00]"
    end
  end

  describe "Equality" do
    it "should be equal when they are identical" do
      route = Route.new(:places => Places.new(center_1, city_1, center_2, city_2))
      route.should == route
    end

    it "should not be equal to nil" do
      route = Route.new(:places => Places.new(center_1, city_1, center_2, city_2))
      route.should_not == nil
    end

    it "should not be equal to other object of another class" do
      route = Route.new(:places => Places.new(center_1, city_1, center_2, city_2))
      route.should_not == 'route'
    end

    it "should not be equal to when the number of trips are different" do
      route_1 = Route.new(:places => Places.new(center_1, city_1, center_2, city_2))
      route_2 = Route.new(:places => Places.new(center_1, city_1, city_2))
      route_1.should_not == route_2
    end

    it "should not be equal to when a city present in one trip is different" do
      route_1 = Route.new(:places => Places.new(center_1, city_1, center_2, city_2))
      route_2 = Route.new(:places => Places.new(center_1, city_1, center_2, city_3))
      route_1.should_not == route_2
    end

    it "should be equal to when the routes are identical" do
      route_1 = Route.new(:places => Places.new(center_1, city_1, center_2, city_2))
      route_2 = Route.new(:places => Places.new(center_1, city_1, center_2, city_2))
      route_1.should == route_2
    end
  end

  describe  "Splitting into trips" do
    it "should split a route into trips properly" do
      route = Route.new(:places => Places.new(center_1, city_1, center_2, city_2))
      trip_1 = Trip.new(:places => Places.new(center_1, city_1, center_1))
      trip_2 = Trip.new(:places => Places.new(center_2, city_2, center_2))

      trips = route.trips
      trips.should have(2).things
      trips.should == [trip_1, trip_2]
    end
  end

  describe "Fitness" do
    it "should know the total distance of the route" do
      Route.new(:places => Places.new(center_1, city_1, city_2)).total_distance.should == 4
      Route.new(:places => Places.new(center_1, city_1, center_2, city_2)).total_distance.should == 8
    end

    it "should know the total overloads of the route" do
      places = Places.new(center_1, city_1, center_2, city_2)
      Route.new(:places => places, :permitted_load => 4).total_overloads.should == 2
      Route.new(:places => places, :permitted_load => 5).total_overloads.should == 1
      Route.new(:places => places, :permitted_load => 6).total_overloads.should == 0
    end

    it "should know the total overloads of the route and pick permitted loads from attributes" do
      route = Route.new(:places => Places.new(center_1, city_1, center_2, city_2), :permitted_load => 5)
      route.total_overloads.should == 1
    end

    it "should know that a fitter route has less overloads" do
      route_1 = Route.new(:places => Places.new(center_1, city_1, center_2, city_2), :permitted_load => 5)
      route_2 = Route.new(:places => Places.new(center_1, city_1, center_2, city_2), :permitted_load => 4)
      route_1.fitter_than?(route_2).should be_true
      route_2.fitter_than?(route_1).should be_false
    end

    it "should know that a fitter route with same overloads has less total distance" do
      route_1 = Route.new(:places => Places.new(center_1, city_1, center_2, city_2), :permitted_load => 5)
      route_2 = Route.new(:places => Places.new(center_1, city_1, city_2), :permitted_load => 5)
      route_1.fitter_than?(route_2).should be_false
      route_2.fitter_than?(route_1).should be_true
    end
  end

  describe "Mutation" do
    it "should form a valid route in all cases" do
      route = Route.new(:places => Places.new(center_1, city_1, center_2, city_2, city_3))
      1.upto(1000) { route.mutate!.should be_valid }
    end

    it "should form combinations of routes allowing alteration in city and center positions when repeated sufficiently" do
      original_route = Route.new(:places => Places.new(center_1, city_1, center_2, city_2))
      mutated_route_1 = Route.new(:places => Places.new(center_1, city_2, center_2, city_1))
      mutated_route_2 = Route.new(:places => Places.new(center_2, city_1, center_1, city_2))
      mutated_route_3 = Route.new(:places => Places.new(center_2, city_2, center_1, city_1))
      serialized_possible_mutated_routes = [original_route, mutated_route_1, mutated_route_2, mutated_route_3].map(&:to_s)

      serialized_mutated_routes = 1.upto(20).collect { original_route.mutate!.to_s }
      serialized_mutated_routes.each{ |route| serialized_possible_mutated_routes.should be_include(route) }
    end
  end
end
