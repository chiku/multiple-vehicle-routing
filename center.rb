# frozen_string_literal: true

require File.dirname(__FILE__) + '/place'

class Center < Place
  def city?
    false
  end

  def center?
    true
  end

  def handle_splits_for_trips(splits)
    splits << Places.new(self)
  end
end
