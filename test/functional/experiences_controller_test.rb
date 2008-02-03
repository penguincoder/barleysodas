require File.dirname(__FILE__) + '/../test_helper'
require 'experiences_controller'

# Re-raise errors caught by the controller.
class ExperiencesController; def rescue_action(e) raise e end; end

class ExperiencesControllerTest < Test::Unit::TestCase
  fixtures :experiences

  def setup
    @controller = ExperiencesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:experiences)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_experience
    old_count = Experience.count
    post :create, :experience => { }
    assert_equal old_count+1, Experience.count
    
    assert_redirected_to experience_path(assigns(:experience))
  end

  def test_should_show_experience
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_experience
    put :update, :id => 1, :experience => { }
    assert_redirected_to experience_path(assigns(:experience))
  end
  
  def test_should_destroy_experience
    old_count = Experience.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Experience.count
    
    assert_redirected_to experiences_path
  end
end
