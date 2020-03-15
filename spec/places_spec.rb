# frozen_string_literal: true

require File.dirname(__FILE__) + '/spec_helper'

describe Places do
  let(:city_1) { City.new(name: 'a', coordinates: Coordinates.new(0, 1), capacity: 5) }
  let(:city_2) { City.new(name: 'b', coordinates: Coordinates.new(0, 2), capacity: 6) }
  let(:city_3) { City.new(name: 'b', coordinates: Coordinates.new(0, 7), capacity: 5) }
  let(:center_1) { Center.new(name: 'A', coordinates: Coordinates.new(0, 3), capacity: 5) }
  let(:center_2) { Center.new(name: 'B', coordinates: Coordinates.new(0, 4), capacity: 6) }

  describe 'at a specified location' do
    let(:places) { Places.new(center_1, city_1) }

    it 'is the place with leading place having location as zero' do
      expect(places.at(0)).to eq center_1
      expect(places.at(1)).to eq city_1
    end

    it 'is nothing when out of range' do
      expect(places.at(2)).to be_instance_of BlankPlace
    end
  end

  describe 'first place' do
    it 'is the place that occurs at the beginning' do
      expect(Places.new(center_1, city_1).first_place).to eq center_1
    end

    it 'is not present in empty places' do
      expect(Places.new.first_place).to be_instance_of(BlankPlace)
    end
  end

  describe 'last place' do
    it 'is the place that occurs at the end' do
      expect(Places.new(center_1, city_1).last_place).to eq city_1
    end

    it 'is not present in empty places' do
      expect(Places.new.last_place).to be_instance_of(BlankPlace)
    end
  end

  describe 'begins with center' do
    it 'is true when the first place is a center' do
      expect(Places.new(center_1, city_1)).to be_begins_with_center
    end

    it 'is false when the first place is a city' do
      expect(Places.new(city_1, center_1)).not_to be_begins_with_center
    end

    it 'is false when no places are present' do
      expect(Places.new).not_to be_begins_with_center
    end
  end

  describe 'intermediates' do
    it 'gives the places except the extremes' do
      places = Places.new(center_1, city_1, city_2, center_1)
      intermediate_places = Places.new(city_1, city_2)
      expect(places.intermediates).to eq intermediate_places
    end
  end

  describe 'has center' do
    it 'is true when a center is present' do
      expect(Places.new(city_1, center_1)).to have_center
    end

    it 'is false when no centers are present' do
      expect(Places.new(city_1, city_2)).not_to have_center
    end

    it 'is false when no places are present' do
      expect(Places.new).not_to have_center
    end
  end

  describe 'ends with center' do
    it 'is true when the last place is a center' do
      expect(Places.new(city_1, center_1)).to be_ends_with_center
    end

    it 'is false when the last place is a city' do
      expect(Places.new(center_1, city_1)).not_to be_ends_with_center
    end

    it 'is false when no places are present' do
      expect(Places.new).not_to be_ends_with_center
    end
  end

  describe 'ends with city' do
    it 'is true when the last place is a city' do
      expect(Places.new(center_1, city_1)).to be_ends_with_city
    end

    it 'is false when the last place is a center' do
      expect(Places.new(center_1, city_1, center_1)).not_to be_ends_with_city
    end

    it 'is false when no places are present' do
      expect(Places.new).not_to be_ends_with_city
    end
  end

  describe 'has same center at extremes' do
    it 'is false when the last place is a city' do
      expect(Places.new(center_1, city_1)).not_to have_same_center_at_extremes
    end

    it 'is false when the first place is a city' do
      expect(Places.new(city_1, center_1)).not_to have_same_center_at_extremes
    end

    it 'is false when centers at beginning and end differ' do
      expect(Places.new(center_1, city_1, center_2)).not_to have_same_center_at_extremes
    end

    it 'is true when centers at beginning and end are same' do
      expect(Places.new(center_1, city_1, center_1)).to have_same_center_at_extremes
    end
  end

  describe 'has unique cities' do
    it 'is false when a city is present twice' do
      expect(Places.new(city_1, city_1)).not_to have_unique_cities
    end

    it 'is true when all cities are unique' do
      expect(Places.new(city_1, city_2)).to have_unique_cities
    end

    it 'is true when all cities are unique with repeated centers' do
      expect(Places.new(center_1, city_1, city_2, center_1)).to have_unique_cities
    end
  end

  describe 'has unique places' do
    it 'is false when a city is present twice' do
      expect(Places.new(center_1, city_1, city_1)).not_to have_unique_places
    end

    it 'is false when a center is present twice' do
      expect(Places.new(center_1, city_1, center_1, city_2)).not_to have_unique_places
    end

    it 'is true when all places are unique' do
      expect(Places.new(center_1, city_1, center_2, city_2)).to have_unique_places
    end
  end

  describe 'has no intermediate center' do
    it 'is true no centers are present in the middle' do
      expect(Places.new(center_1, city_1, center_1)).to have_no_intermediate_center
    end

    it 'is false when a center is present in the middle' do
      expect(Places.new(center_1, center_2, city_1, center_1)).not_to have_no_intermediate_center
    end
  end

  describe 'has no consecutive centers' do
    it 'is true when no centers are present together' do
      expect(Places.new(center_1, center_2, city_1)).not_to have_no_consecutive_center
    end

    it 'is false when a center are separated by cities' do
      expect(Places.new(center_1, city_1, center_2, city_2)).to have_no_consecutive_center
    end
  end

  describe 'add' do
    it 'builds up the places' do
      places = Places.new
      places << center_1
      places << city_1
      expect(places.places[0]).to eq center_1
      expect(places.places[1]).to eq city_1
    end
  end

  describe 'to_s' do
    it 'serialize to a string' do
      expect(Places.new(center_1, city_1, city_2, center_1).to_s).to eq '(A -> a -> b -> A)'
    end
  end

  describe 'equals' do
    let(:places) { Places.new(center_1, city_1, city_2, center_1) }

    it 'itself' do
      expect(places).to eq places
    end

    it 'another places with same order' do
      another_places = Places.new(center_1, city_1, city_2, center_1)
      expect(places).to eq another_places
    end
  end

  describe 'reverse' do
    it 'is the list of places read backwards' do
      reversed_places = Places.new(center_1, city_1, city_2, center_1).reverse

      places_array = reversed_places.places
      expect(places_array).to have(4).entries
      expect(places_array[0]).to eq center_1
      expect(places_array[1]).to eq city_2
      expect(places_array[2]).to eq city_1
      expect(places_array[3]).to eq center_1
    end
  end

  describe "doesn't equal" do
    let(:places) { Places.new(center_1, city_1, city_2, center_1) }
    let(:diferent_city) { City.new(name: 'c', coordinates: Coordinates.new(0, -2), capacity: 6) }

    it 'nil' do
      expect(places).not_to eq nil
    end

    it 'center' do
      expect(places).not_to eq center_1
    end

    it 'another places that begins with different center' do
      another_places = Places.new(center_2, city_1, city_2, center_1)
      expect(places).not_to eq another_places
    end

    it 'another place that ends with different center' do
      another_places = Places.new(center_1, city_1, city_2, center_2)
      expect(places).not_to eq another_places
    end

    it 'another place that one different city' do
      another_places = Places.new(center_1, city_1, diferent_city, center_2)
      expect(places).not_to eq another_places
    end

    it 'another place that one extra city' do
      another_places = Places.new(center_1, city_1, city_2, diferent_city, center_2)
      expect(places).not_to eq another_places
    end

    it 'another place that one less city' do
      another_places = Places.new(center_1, city_1, center_2)
      expect(places).not_to eq another_places
    end

    it 'another places with reverse order' do
      another_places = Places.new(center_1, city_2, city_1, center_1)
      expect(places).not_to eq another_places
    end
  end

  describe 'hash' do
    it 'is same hash for when equal' do
      expect(Places.new(center_1, city_1, center_1).hash).to eq Places.new(center_1, city_1, center_1).hash
    end
  end

  describe 'round trip distance' do
    it 'is the sum of distance between two consecutive places' do
      expect(Places.new(center_1, city_1, center_1).round_trip_distance).to eq 4.0
      expect(Places.new(center_2, city_1, city_2, center_2).round_trip_distance).to eq 6.0
    end
  end

  describe 'size' do
    it 'is the number of places present' do
      expect(Places.new(center_1, city_1, city_2)).to have(3).entries
    end
  end

  describe 'interchange positions' do
    it 'exchanges two places' do
      places = Places.new(center_1, city_1, city_2)
      places.interchange_positions!(0, 1)
      expect(places.places).to eq [city_1, center_1, city_2]
    end
  end

  describe 'equivalent positions' do
    it 'is true when the places refered by positions are cities' do
      expect(Places.new(center_1, city_1, city_2)).to be_equivalent_positions(1, 2)
    end

    it 'is true when the places refered by positions are centers' do
      expect(Places.new(center_1, city_1, center_2, city_2)).to be_equivalent_positions(0, 2)
    end

    it 'is false when the places refered by positions are a city and a center' do
      expect(Places.new(center_1, city_1, city_2)).not_to be_equivalent_positions(0, 2)
    end
  end

  describe 'interchange positions on equivalence' do
    it 'exchanges two cites' do
      places = Places.new(center_1, city_1, city_2)
      places.interchange_positions_on_equivalence!(1, 2)
      expect(places.places).to eq [center_1, city_2, city_1]
    end

    it 'exchanges two centers' do
      places = Places.new(center_1, city_1, center_2)
      places.interchange_positions_on_equivalence!(0, 2)
      expect(places.places).to eq [center_2, city_1, center_1]
    end

    it "doesn't exchange a city and a center" do
      places = Places.new(center_1, city_1, city_2)
      places.interchange_positions_on_equivalence!(0, 1)
      expect(places.places).to eq [center_1, city_1, city_2]
    end
  end

  describe 'replicate first place to end' do
    it 'copies over copies over the beginning place to the end' do
      places = Places.new(center_1, city_1, city_2)
      expect(places.replicate_first_place_to_end).to eq Places.new(center_1, city_1, city_2, center_1)
      expect(places.places).to eq [center_1, city_1, city_2, center_1]
    end
  end

  describe 'split by leading center' do
    it 'gives an array of the cities separated by its leading center' do
      sub_places = Places.new(center_1, city_1, city_2, center_2, city_3).split_by_leading_center
      expect(sub_places).to have(2).things
      expect(sub_places[0].places).to eq [center_1, city_1, city_2]
      expect(sub_places[1].places).to eq [center_2, city_3]
    end

    it "doesn't include cities without a leading center" do
      sub_places = Places.new(city_1, city_2, center_2, city_3).split_by_leading_center
      expect(sub_places).to have(1).entry
      expect(sub_places[0].places).to eq [center_2, city_3]
    end
  end
end
