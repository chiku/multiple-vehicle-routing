# frozen_string_literal: true

require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RuboCop::RakeTask.new

desc 'Run specs'
task :spec do
  RSpec::Core::RakeTask.new
end

task default: :spec
