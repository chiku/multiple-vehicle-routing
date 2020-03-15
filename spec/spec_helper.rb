# frozen_string_literal: true

require 'simplecov'
require 'rspec'
require 'rspec/collection_matchers'

SimpleCov.start

Dir[File.join(__dir__, '..', '*.rb')].sort.each do |file|
  require file
end
