require File.dirname(__FILE__) + '/../test_helper'
require 'invitations_controller'

# Re-raise errors caught by the controller.
class InvitationsController; def rescue_action(e) raise e end; end

class InvitationsControllerTest < Test::Unit::TestCase
  fixtures :invitations

  def setup
    @controller = InvitationsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:invitations)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_invitation
    old_count = Invitation.count
    post :create, :invitation => { }
    assert_equal old_count+1, Invitation.count
    
    assert_redirected_to invitation_path(assigns(:invitation))
  end

  def test_should_show_invitation
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_invitation
    put :update, :id => 1, :invitation => { }
    assert_redirected_to invitation_path(assigns(:invitation))
  end
  
  def test_should_destroy_invitation
    old_count = Invitation.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Invitation.count
    
    assert_redirected_to invitations_path
  end
end
