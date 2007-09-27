require File.dirname(__FILE__) + '/../test_helper'

class PageTest < Test::Unit::TestCase
  fixtures :pages
  
  def test_create
    assert_create('Page', :title => 'my test page')
  end
  
  def test_destroy
    assert_destroy('Page')
  end
end
