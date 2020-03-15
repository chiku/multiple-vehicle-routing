# frozen_string_literal: true

require 'rspec'
require 'rspec/collection_matchers'

Dir[File.join(__dir__, '..', '*.rb')].sort.each do |file|
  require file
end
