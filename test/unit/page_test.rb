require File.dirname(__FILE__) + '/../test_helper'

class PageTest < Test::Unit::TestCase
  fixtures :pages
  
  def test_create
    assert_create('Page', :title => 'my test page')
  end
  
  def test_destroy
    assert_destroy('Page')
  end

  def test_no_html_in_tag
    p = Page.new :title => 'test page', :redcloth => '<ul><li>list</li></ul>'
    p.save
    assert p.html !~ /ul/
  end
end
