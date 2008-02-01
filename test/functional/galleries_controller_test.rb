require File.dirname(__FILE__) + '/../test_helper'
require 'images_controller'

# Re-raise errors caught by the controller.
class GalleriesController; def rescue_action(e) raise e end; end

class GalleriesControllerTest < Test::Unit::TestCase
  fixtures :images

  def setup
    @controller = GalleriesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:images)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_images
    old_count = Images.count
    post :create, :images => { }
    assert_equal old_count+1, Images.count
    
    assert_redirected_to images_path(assigns(:images))
  end

  def test_should_show_images
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_images
    put :update, :id => 1, :images => { }
    assert_redirected_to images_path(assigns(:images))
  end
  
  def test_should_destroy_images
    old_count = Images.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Images.count
    
    assert_redirected_to images_path
  end
end
