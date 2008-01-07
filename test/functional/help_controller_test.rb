require File.dirname(__FILE__) + '/../test_helper'
require 'help_controller'

# Re-raise errors caught by the controller.
class HelpController; def rescue_action(e) raise e end; end

class HelpControllerTest < Test::Unit::TestCase
  fixtures :help

  def setup
    @controller = HelpController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:helps)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_help
    old_count = Help.count
    post :create, :help => { }
    assert_equal old_count+1, Help.count
    
    assert_redirected_to help_path(assigns(:help))
  end

  def test_should_show_help
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_help
    put :update, :id => 1, :help => { }
    assert_redirected_to help_path(assigns(:help))
  end
  
  def test_should_destroy_help
    old_count = Help.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Help.count
    
    assert_redirected_to helps_path
  end
end
