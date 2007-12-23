require File.dirname(__FILE__) + '/../test_helper'
require 'peoples_controller'

# Re-raise errors caught by the controller.
class PeoplesController; def rescue_action(e) raise e end; end

class PeoplesControllerTest < Test::Unit::TestCase
  fixtures :peoples

  def setup
    @controller = PeoplesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:peoples)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_people
    old_count = People.count
    post :create, :people => { :title => 'mypeople', :role_id => 1 }
    assert_equal old_count+1, People.count
    
    assert_redirected_to people_path(assigns(:people).page.title_for_url)
  end

  def test_should_show_people
    get :show, :id => 'penguin_coder'
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 'penguin_coder'
    assert_response :success
  end
  
  def test_should_update_people
    put :update, :id => 'penguin_coder',
      :people => { :title => 'penguin coder' }
    assert_redirected_to people_path(assigns(:people).page.title_for_url)
  end
  
  def test_should_destroy_people
    old_count = People.count
    delete :destroy, :id => 'penguin_coder'
    assert_equal old_count-1, People.count
    
    assert_redirected_to peoples_path
  end
end
