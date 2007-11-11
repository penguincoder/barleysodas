require File.dirname(__FILE__) + '/../test_helper'
require 'beers_controller'

# Re-raise errors caught by the controller.
class BeersController; def rescue_action(e) raise e end; end

class BeersControllerTest < Test::Unit::TestCase
  fixtures :beers, :pages

  def setup
    @controller = BeersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:beers)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_beer
    old_count = Beer.count
    post :create, :beer => { :title => '1' }
    assert_equal old_count+1, Beer.count

    assert_redirected_to beer_path(assigns(:beer).page.title_for_url)
  end

  def test_should_show_beer
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end

  def test_should_update_beer
    put :update, :id => 1, :beer => { :title => '1' }
    assert_redirected_to beer_path(assigns(:beer).page.title_for_url)
  end

  def test_should_destroy_beer
    old_count = Beer.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Beer.count

    assert_redirected_to beers_path
  end
end
