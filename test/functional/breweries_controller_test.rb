require File.dirname(__FILE__) + '/../test_helper'
require 'breweries_controller'

# Re-raise errors caught by the controller.
class BreweriesController; def rescue_action(e) raise e end; end

class BreweriesControllerTest < Test::Unit::TestCase
  fixtures :breweries
  
  def setup
    @controller = BreweriesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:breweries)
  end
  
  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_brewery
    old_count = Brewery.count
    post :create, :brewery => { :title => 'title' }
    assert_equal old_count+1, Brewery.count
    
    assert_redirected_to brewery_path(assigns(:brewery).page.title_for_url)
  end

  def test_should_show_brewery
    get :show, :id => 1
    assert_response :success
  end
  
  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_brewery
    put :update, :id => 1, :brewery => { :title => '1' }
    assert_redirected_to brewery_path(assigns(:brewery).page.title_for_url)
  end
  
  def test_should_destroy_brewery
    old_count = Brewery.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Brewery.count
    
    assert_redirected_to breweries_path
  end
end
