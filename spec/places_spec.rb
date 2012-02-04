require File.dirname(__FILE__) + '/spec_helper'

describe Places do
  let(:city_1) { City.new(:name => 'a', :x_coordinate => 0, :y_coordinate => 1, :capacity => 5) }
  let(:city_2) { City.new(:name => 'b', :x_coordinate => 0, :y_coordinate => 2, :capacity => 6) }
  let(:center_1) { Center.new(:name => 'A', :x_coordinate => 0, :y_coordinate => 3, :capacity => 5) }
  let(:center_2) { Center.new(:name => 'B', :x_coordinate => 0, :y_coordinate => 4, :capacity => 6) }

  context "first place" do
    it "is the place that occurs at the beginning" do
      Places.new(center_1, city_1).first_place.should == center_1
    end

    it "is not present in empty places" do
      Places.new.first_place.should be_instance_of(BlankPlace)
    end
  end

  context "begins with center" do
    it "is true when the first place is a center" do
      Places.new(center_1, city_1).should be_begins_with_center
    end

    it "is false when the first place is a city" do
      Places.new(city_1, center_1).should_not be_begins_with_center
    end

    it "is false when no places are present" do
      Places.new.should_not be_begins_with_center
    end
  end 

  context "last place" do
    it "is the place that occurs at the end" do
      Places.new(center_1, city_1).last_place.should == city_1
    end

    it "is not present in empty places" do
      Places.new.last_place.should be_instance_of(BlankPlace)
    end
  end

  context "intermediates" do
    it "gives the places except the extremes" do
      places = Places.new(center_1, city_1, city_2, center_1)
      intermediate_places = Places.new(city_1, city_2)
      places.intermediates.should == intermediate_places
    end
  end

  context "ends with center" do
    it "is true when the last place is a center" do
      Places.new(city_1, center_1).should be_ends_with_center
    end

    it "is false when the last place is a city" do
      Places.new(center_1, city_1).should_not be_ends_with_center
    end

    it "is false when no places are present" do
      Places.new.should_not be_ends_with_center
    end
  end 

  context "has same center at extremes" do
    it "is false when the last place is a city" do
      Places.new(center_1, city_1).should_not have_same_center_at_extremes
    end

    it "is false when the first place is a city" do
      Places.new(city_1, center_1).should_not have_same_center_at_extremes
    end

    it "is false when centers at beginning and end differ" do
      Places.new(center_1, city_1, center_2).should_not have_same_center_at_extremes
    end

    it "is true when centers at beginning and end are same" do
      Places.new(center_1, city_1, center_1).should have_same_center_at_extremes
    end
  end

  context "has unique cities" do
    it "is false when a city is present twice" do
      Places.new(city_1, city_1).should_not have_unique_cities
    end

    it "is true when all cities are unique" do
      Places.new(city_1, city_2).should have_unique_cities
    end

    it "is true when all cities are unique with repeated centers" do
      Places.new(center_1, city_1, city_2, center_1).should have_unique_cities
    end
  end

  context "has no intermediate center" do
    it "is true no centers are present in the middle" do
      Places.new(center_1, city_1, center_1).should have_no_intermediate_center
    end

    it "is false when a center is present in the middle" do
      Places.new(center_1, center_2, city_1, center_1).should_not have_no_intermediate_center
    end
  end

  context "add" do
    it "builds up the places" do
      places = Places.new
      places.add center_1
      places.add city_1
      places.places[0].should == center_1
      places.places[1].should == city_1
    end
  end

  context "to_s" do
    it "serialize to a string" do
      Places.new(center_1, city_1, city_2, center_1).to_s.should == "(A -> a -> b -> A)"
    end
  end

  context "equals" do
    let(:places) { Places.new(center_1, city_1, city_2, center_1) }

    it "itself" do
      places.should == places
    end

    it "another places with same order" do
      another_places = Places.new(center_1, city_1, city_2, center_1)
      places.should == another_places
    end
  end

  context "reverse" do
    it "is the list of places read backwards" do
      reversed_places = Places.new(center_1, city_1, city_2, center_1).reverse

      places_array = reversed_places.places
      places_array.should have(4).things
      places_array[0].should == center_1
      places_array[1].should == city_2
      places_array[2].should == city_1
      places_array[3].should == center_1
    end
  end

  context "doesn't equal" do
    let(:places) { Places.new(center_1, city_1, city_2, center_1) }
    let(:diferent_city) { City.new(:name => 'c', :x_coordinate => 0, :y_coordinate => -2, :capacity => 6) }

    it "nil" do
      places.should_not == nil
    end

    it "center" do
      places.should_not == center_1
    end

    it "another places that begins with different center" do
      another_places = Places.new(center_2, city_1, city_2, center_1)
      places.should_not == another_places
    end

    it "another place that ends with different center" do
      another_places = Places.new(center_1, city_1, city_2, center_2)
      places.should_not == another_places
    end

    it "another place that one different city" do
      another_places = Places.new(center_1, city_1, diferent_city, center_2)
      places.should_not == another_places
    end

    it "another place that one extra city" do
      another_places = Places.new(center_1, city_1, city_2, diferent_city, center_2)
      places.should_not == another_places
    end

    it "another place that one less city" do
      another_places = Places.new(center_1, city_1, center_2)
      places.should_not == another_places
    end

    it "another places with reverse order" do
      another_places = Places.new(center_1, city_2, city_1, center_1)
      places.should_not == another_places
    end
  end

  context "hash" do
    it "is same hash for when equal" do
      Places.new(center_1, city_1, center_1).hash == Places.new(center_1, city_1, center_1).hash
    end
  end

  context "round trip distance" do
    it "is the sum of distance between two consecutive places" do
      Places.new(center_1, city_1, center_1).round_trip_distance.should == 4.0
      Places.new(center_2, city_1, city_2, center_2).round_trip_distance.should == 6.0
    end
  end
end