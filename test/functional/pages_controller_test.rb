require File.dirname(__FILE__) + '/../test_helper'
require 'pages_controller'

# Re-raise errors caught by the controller.
class PagesController; def rescue_action(e) raise e end; end

class PagesControllerTest < Test::Unit::TestCase
  fixtures :pages

  def setup
    @controller = PagesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:page)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_page
    old_count = Page.count
    post :create, :page => { :title => 'TestPage' }
    assert_equal old_count+1, Page.count
    
    assert_redirected_to page_path(assigns(:page))
  end

  def test_should_show_page
    get :show, :id => 'HomePage'
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 'HomePage'
    assert_response :success
  end
  
  def test_should_update_page
    put :update, :id => 'HomePage', :page => { :title => 'HomePage' }
    assert_redirected_to page_path(assigns(:page))
  end
  
  def test_should_destroy_page
    old_count = Page.count
    delete :destroy, :id => 'HomePage'
    assert_equal old_count-1, Page.count
    
    assert_redirected_to pages_path
  end
end
