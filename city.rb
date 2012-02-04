require File.dirname(__FILE__) + '/place'

class City < Place
  def city?
    true
  end

  def center?
    false
  end
end
