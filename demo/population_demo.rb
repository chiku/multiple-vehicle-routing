#!/usr/bin/env ruby
# frozen_string_literal: true

require File.join(__dir__, '..', 'route.rb')
require File.join(__dir__, '..', 'places.rb')
require File.join(__dir__, '..', 'center.rb')
require File.join(__dir__, '..', 'city.rb')
require File.join(__dir__, '..', 'coordinates.rb')
require File.join(__dir__, '..', 'population.rb')

city_a = City.new name: 'a', coordinates: Coordinates.new(10, 14), capacity: 9
city_b = City.new name: 'b', coordinates: Coordinates.new(15, 20), capacity: 7
city_c = City.new name: 'c', coordinates: Coordinates.new(11, 30), capacity: 6
city_d = City.new name: 'd', coordinates: Coordinates.new(17, 23), capacity: 6
city_e = City.new name: 'e', coordinates: Coordinates.new(6,  3), capacity: 6
center_a = Center.new name: 'A', coordinates: Coordinates.new(9, 11), capacity: 22
places = Places.new(center_a, city_a, city_b, city_c, city_d, city_e)

Population.new(places: places, permitted_load: 30, max_generation_runs: 20).run
