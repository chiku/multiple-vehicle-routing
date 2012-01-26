describe "Place distance checks", :shared => true do
  it "should know its distance from another place" do
    place_1 = @klass.new(:name => 'a', :x_coordinate => 0, :y_coordinate => 0)
    place_2 = @klass.new(:name => 'b', :x_coordinate => 3, :y_coordinate => 4)
    place_1.distance(place_2).should == 5.0
    place_2.distance(place_1).should == 5.0
  end
  
  it "should know its distance from place of another type" do
    place_1 = @klass.new(:name => 'a', :x_coordinate => 0, :y_coordinate => 0)
    place_2 = @other_klass.new(:name => 'b', :x_coordinate => 3, :y_coordinate => 4)
    place_1.distance(place_2).should == 5.0
    place_2.distance(place_1).should == 5.0
  end
end
