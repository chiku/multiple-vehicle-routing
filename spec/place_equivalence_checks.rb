shared_examples_for "Place equivalence checks" do
  it "should be equal when they are identical" do
    place_1 = klass.new(:name => 'a', :x_coordinate => 0, :y_coordinate => 0, :capacity => 10)
    place_1.should == place_1
  end

  it "should not be equal to nil" do
    place_1 = klass.new(:name => 'a', :x_coordinate => 0, :y_coordinate => 0, :capacity => 10)
    place_1.should_not == nil
  end

  it "should not be equal to object of another class" do
    place_1 = klass.new(:name => 'a', :x_coordinate => 0, :y_coordinate => 0, :capacity => 10)
    place_2 = other_klass.new(:name => 'a', :x_coordinate => 0, :y_coordinate => 0, :capacity => 10)
    place_1.should_not == place_2
  end

  it "should be not equal when names are not equal" do
    place_1 = klass.new(:name => 'a', :x_coordinate => 0, :y_coordinate => 0, :capacity => 10)
    place_2 = klass.new(:name => 'b', :x_coordinate => 0, :y_coordinate => 0, :capacity => 10)
    place_1.should_not == place_2
  end

  it "should be not equal when x_coordinates are not equal" do
    place_1 = klass.new(:name => 'a', :x_coordinate => 3, :y_coordinate => 4, :capacity => 10)
    place_2 = klass.new(:name => 'a', :x_coordinate => 4, :y_coordinate => 4, :capacity => 10)
    place_1.should_not == place_2
  end

  it "should be not equal when y-coordinates are not equal" do
    place_1 = klass.new(:name => 'a', :x_coordinate => 3, :y_coordinate => 4, :capacity => 10)
    place_2 = klass.new(:name => 'b', :x_coordinate => 3, :y_coordinate => 5, :capacity => 10)
    place_1.should_not == place_2
  end

  it "should be not equal when names are not equal" do
    place_1 = klass.new(:name => 'a', :x_coordinate => 0, :y_coordinate => 0, :capacity => 10)
    place_2 = klass.new(:name => 'b', :x_coordinate => 0, :y_coordinate => 0, :capacity => 10)
    place_1.should_not == place_2
  end

  it "should be not equal when capacities are not equal" do
    place_1 = klass.new(:name => 'a', :x_coordinate => 0, :y_coordinate => 1, :capacity => 10)
    place_2 = klass.new(:name => 'b', :x_coordinate => 0, :y_coordinate => 1, :capacity => 11)
    place_1.should_not == place_2
  end

  it "should be equal when all its attributes are equal" do
    place_1 = klass.new(:name => 'a', :x_coordinate => 3, :y_coordinate => 4, :capacity => 10)
    place_2 = klass.new(:name => 'a', :x_coordinate => 3, :y_coordinate => 4, :capacity => 10)
    place_1.should == place_2
  end

  it "should be have same hash for equal objects" do
    place_1 = klass.new(:name => 'a', :x_coordinate => 3, :y_coordinate => 4, :capacity => 10)
    place_2 = klass.new(:name => 'a', :x_coordinate => 3, :y_coordinate => 4, :capacity => 10)
    place_1.hash.should == place_2.hash
  end
end
