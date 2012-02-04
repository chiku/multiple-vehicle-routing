require File.dirname(__FILE__) + '/place'

class Center < Place
  def city?
    false
  end

  def center?
    true
  end
end
