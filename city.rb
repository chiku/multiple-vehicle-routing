# frozen_string_literal: true

require File.dirname(__FILE__) + '/place'

class City < Place
  def city?
    true
  end

  def center?
    false
  end

  def handle_splits_for_trips(splits)
    splits.last << self
  end
end
