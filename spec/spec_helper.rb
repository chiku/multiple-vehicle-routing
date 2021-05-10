# frozen_string_literal: true

src = File.expand_path(File.join(__dir__, '..', 'src'))
$LOAD_PATH.unshift(src) unless $LOAD_PATH.include?(src)

require 'simplecov'
require 'rspec'
require 'rspec/collection_matchers'

SimpleCov.start

Dir[File.expand_path(File.join(__dir__, '..', 'src', '**', '*.rb'))].sort.each do |file|
  require file
end

Dir[File.expand_path(File.join(__dir__, '**', '*_checks.rb'))].sort.each do |file|
  require file
end

RSpec.configure do |config|
  config.expect_with(:rspec) do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with(:rspec) do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
