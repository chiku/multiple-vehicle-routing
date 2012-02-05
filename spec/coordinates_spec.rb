require File.dirname(__FILE__) + '/spec_helper'

describe Coordinates do
  it "knows its x-coordinate" do
    Coordinates.new(10, 5).x.should == 10
  end

  it "knows its y-coordinate" do
    Coordinates.new(10, 5).y.should == 5
  end

  describe "equals" do
    it "itself" do
      c = Coordinates.new(2, 4)
      c.should == c
    end

    it "another coordinate with same x and y coordinates" do
      Coordinates.new(2, 4).should == Coordinates.new(2, 4)
    end
  end

  describe "doesn't equal" do
    it "coordinate with a different x" do
      Coordinates.new(2, 4).should_not == Coordinates.new(1, 4)
    end

    it "coordinate with a different y" do
      Coordinates.new(2, 4).should_not == Coordinates.new(2, -4)
    end

    it "nil" do
      Coordinates.new(2, 4).should_not == nil
    end

    it "object not an instance of Coordinates" do
      Coordinates.new(2, 4).should_not == Array.new
    end
  end

  it "knows it distance from another coordinate" do
    Coordinates.new(2, 3).distance_from(Coordinates.new(5, 7)).should == 5
  end

  describe "hash" do
    it "is equal when identical" do
      c1 = Coordinates.new(1, 3)
      c2 = Coordinates.new(1, 3)
      c1.hash.should == c2.hash
    end
  end
end
