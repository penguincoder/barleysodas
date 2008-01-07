require File.dirname(__FILE__) + '/../test_helper'
require 'styles_controller'

# Re-raise errors caught by the controller.
class StylesController; def rescue_action(e) raise e end; end

class StylesControllerTest < Test::Unit::TestCase
  fixtures :styles

  def setup
    @controller = StylesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:styles)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_style
    old_count = Style.count
    post :create, :style => { }
    assert_equal old_count+1, Style.count
    
    assert_redirected_to style_path(assigns(:style))
  end

  def test_should_show_style
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_style
    put :update, :id => 1, :style => { }
    assert_redirected_to style_path(assigns(:style))
  end
  
  def test_should_destroy_style
    old_count = Style.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Style.count
    
    assert_redirected_to styles_path
  end
end
