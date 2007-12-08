require File.dirname(__FILE__) + '/../test_helper'

class PageTest < Test::Unit::TestCase
  fixtures :pages
  
  def test_create
    assert_create('Page', :title => 'my test page')
  end
  
  def test_destroy
    assert_destroy('Page')
  end

  def test_url_titles
    p = Page.new :title => 'Test Title'
    assert Page.title_from_url('Test_Title') == p.title
    assert p.title_for_url == 'Test_Title'
  end
end
