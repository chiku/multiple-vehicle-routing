#!/usr/bin/env ruby
# frozen_string_literal: true

src = File.expand_path(File.join(__dir__, '..', 'src'))
$LOAD_PATH.unshift src unless $LOAD_PATH.include?(src)

require 'multiple_vehicle_routing'

city_a = MultipleVehicleRouting::City.new name: 'a', coordinates: MultipleVehicleRouting::Coordinates.new(10, 14), capacity: 9
city_b = MultipleVehicleRouting::City.new name: 'b', coordinates: MultipleVehicleRouting::Coordinates.new(15, 20), capacity: 7
city_c = MultipleVehicleRouting::City.new name: 'c', coordinates: MultipleVehicleRouting::Coordinates.new(11, 30), capacity: 6
city_d = MultipleVehicleRouting::City.new name: 'd', coordinates: MultipleVehicleRouting::Coordinates.new(17, 23), capacity: 6
city_e = MultipleVehicleRouting::City.new name: 'e', coordinates: MultipleVehicleRouting::Coordinates.new(6,  3), capacity: 6
center_a = MultipleVehicleRouting::Center.new name: 'A', coordinates: MultipleVehicleRouting::Coordinates.new(9, 11), capacity: 22
places = MultipleVehicleRouting::Places.new(center_a, city_a, city_b, city_c, city_d, city_e)

MultipleVehicleRouting::Population.new(places: places, permitted_load: 30, max_generation_runs: 20).run
