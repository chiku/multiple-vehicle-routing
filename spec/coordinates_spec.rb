require File.dirname(__FILE__) + '/spec_helper'

describe Coordinates do
  it "knows its x-coordinate" do
    expect(Coordinates.new(10, 5).x).to eq 10
  end

  it "knows its y-coordinate" do
    expect(Coordinates.new(10, 5).y).to eq 5
  end

  describe "equals" do
    it "itself" do
      c = Coordinates.new(2, 4)
      expect(c).to eq c
    end

    it "another coordinate with same x and y coordinates" do
      expect(Coordinates.new(2, 4)).to eq Coordinates.new(2, 4)
    end
  end

  describe "doesn't equal" do
    it "coordinate with a different x" do
      expect(Coordinates.new(2, 4)).not_to eq Coordinates.new(1, 4)
    end

    it "coordinate with a different y" do
      expect(Coordinates.new(2, 4)).not_to eq Coordinates.new(2, -4)
    end

    it "nil" do
      expect(Coordinates.new(2, 4)).not_to eq nil
    end

    it "object not an instance of Coordinates" do
      expect(Coordinates.new(2, 4)).not_to eq Array.new
    end
  end

  it "knows it distance from another coordinate" do
    expect(Coordinates.new(2, 3).distance_from(Coordinates.new(5, 7))).to eq 5
  end

  describe "hash" do
    it "is equal when identical" do
      c1 = Coordinates.new(1, 3)
      c2 = Coordinates.new(1, 3)
      expect(c1.hash).to eq c2.hash
    end
  end
end
