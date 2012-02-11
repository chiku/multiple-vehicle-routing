shared_examples_for "Place" do |klass, other_klass|
  context "in test for equality" do
    it "should be equal when they are identical" do
      place_1 = klass.new(:name => 'a', :coordinates => Coordinates.new(0, 0), :capacity => 10)
      place_1.should == place_1
    end

    it "should not be equal to nil" do
      place_1 = klass.new(:name => 'a', :coordinates => Coordinates.new(0, 0), :capacity => 10)
      place_1.should_not == nil
    end

    it "should not be equal to object of another class" do
      place_1 = klass.new(:name => 'a', :coordinates => Coordinates.new(0, 0), :capacity => 10)
      place_2 = other_klass.new(:name => 'a', :coordinates => Coordinates.new(0, 0), :capacity => 10)
      place_1.should_not == place_2
    end

    it "should be not equal when names are not equal" do
      place_1 = klass.new(:name => 'a', :coordinates => Coordinates.new(0, 0), :capacity => 10)
      place_2 = klass.new(:name => 'b', :coordinates => Coordinates.new(0, 0), :capacity => 10)
      place_1.should_not == place_2
    end

    it "should be not equal when x_coordinates are not equal" do
      place_1 = klass.new(:name => 'a', :coordinates => Coordinates.new(3, 4), :capacity => 10)
      place_2 = klass.new(:name => 'a', :coordinates => Coordinates.new(4, 4), :capacity => 10)
      place_1.should_not == place_2
    end

    it "should be not equal when y-coordinates are not equal" do
      place_1 = klass.new(:name => 'a', :coordinates => Coordinates.new(3, 4), :capacity => 10)
      place_2 = klass.new(:name => 'b', :coordinates => Coordinates.new(3, 5), :capacity => 10)
      place_1.should_not == place_2
    end

    it "should be not equal when names are not equal" do
      place_1 = klass.new(:name => 'a', :coordinates => Coordinates.new(0, 0), :capacity => 10)
      place_2 = klass.new(:name => 'b', :coordinates => Coordinates.new(0, 0), :capacity => 10)
      place_1.should_not == place_2
    end

    it "should be not equal when capacities are not equal" do
      place_1 = klass.new(:name => 'a', :coordinates => Coordinates.new(0, 1), :capacity => 10)
      place_2 = klass.new(:name => 'b', :coordinates => Coordinates.new(0, 1), :capacity => 11)
      place_1.should_not == place_2
    end

    it "should be equal when all its attributes are equal" do
      place_1 = klass.new(:name => 'a', :coordinates => Coordinates.new(3, 4), :capacity => 10)
      place_2 = klass.new(:name => 'a', :coordinates => Coordinates.new(3, 4), :capacity => 10)
      place_1.should == place_2
    end

    it "should be have same hash for equal objects" do
      place_1 = klass.new(:name => 'a', :coordinates => Coordinates.new(3, 4), :capacity => 10)
      place_2 = klass.new(:name => 'a', :coordinates => Coordinates.new(3, 4), :capacity => 10)
      place_1.hash.should == place_2.hash
    end
  end

  context "when finding distance" do
    it "should know its distance from another place" do
      place_1 = klass.new(:name => 'a', :coordinates => Coordinates.new(0, 0))
      place_2 = klass.new(:name => 'b', :coordinates => Coordinates.new(3, 4))
      place_1.distance(place_2).should == 5.0
      place_2.distance(place_1).should == 5.0
    end

    it "should know its distance from place of another type" do
      place_1 = klass.new(:name => 'a', :coordinates => Coordinates.new(0, 0))
      place_2 = other_klass.new(:name => 'b', :coordinates => Coordinates.new(3, 4))
      place_1.distance(place_2).should == 5.0
      place_2.distance(place_1).should == 5.0
    end
  end
end