require File.dirname(__FILE__) + '/../test_helper'
require 'tag_images_controller'

# Re-raise errors caught by the controller.
class TagImagesController; def rescue_action(e) raise e end; end

class TagImagesControllerTest < Test::Unit::TestCase
  fixtures :tag_images

  def setup
    @controller = TagImagesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:tag_images)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_tag_image
    old_count = TagImage.count
    post :create, :tag_image => { }
    assert_equal old_count+1, TagImage.count
    
    assert_redirected_to tag_image_path(assigns(:tag_image))
  end

  def test_should_show_tag_image
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_tag_image
    put :update, :id => 1, :tag_image => { }
    assert_redirected_to tag_image_path(assigns(:tag_image))
  end
  
  def test_should_destroy_tag_image
    old_count = TagImage.count
    delete :destroy, :id => 1
    assert_equal old_count-1, TagImage.count
    
    assert_redirected_to tag_images_path
  end
end
