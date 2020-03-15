require 'rspec'
require 'rspec/collection_matchers'

Dir[File.join(File.expand_path(File.dirname(__FILE__)), "..", "*.rb")].each do |file|
  require file
end
