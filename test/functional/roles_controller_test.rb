require File.dirname(__FILE__) + '/../test_helper'
require 'roles_controller'

# Re-raise errors caught by the controller.
class RolesController; def rescue_action(e) raise e end; end

class RolesControllerTest < Test::Unit::TestCase
  fixtures :roles

  def setup
    @controller = RolesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:roles)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_role
    old_count = Role.count
    post :create, :role => { :code => 'test', :name => 'test role' }
    assert_equal old_count+1, Role.count
    
    assert_redirected_to role_path(assigns(:role).code)
  end

  def test_should_show_role
    get :show, :id => 'base'
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 'base'
    assert_response :success
  end
  
  def test_should_update_role
    put :update, :id => 'base', :role => { :name => 'base role new!' }
    assert_redirected_to role_path(assigns(:role).code)
  end
  
  def test_should_destroy_role
    old_count = Role.count
    delete :destroy, :id => 'base'
    assert_equal old_count-1, Role.count
    
    assert_redirected_to roles_path
  end
end
