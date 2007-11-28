require File.dirname(__FILE__) + '/../test_helper'
require 'discussions_controller'

# Re-raise errors caught by the controller.
class DiscussionsController; def rescue_action(e) raise e end; end

class DiscussionsControllerTest < Test::Unit::TestCase
  fixtures :discussions

  def setup
    @controller = DiscussionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:pages)
  end

  def test_should_create_discussion
    old_count = Discussion.count
    post :create, :discussion => { :page_id => 1 }
    assert_equal old_count+1, Discussion.count
    assert_response :success
  end

  def test_should_show_discussion
    get :show, :id => 1
    assert_response :success
  end

  def test_should_update_discussion
    put :update, :id => 1, :discussion => { :page_id => 1 }
    assert_response :success
  end

  def test_should_destroy_discussion
    old_count = Discussion.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Discussion.count
    assert_response :success
  end
end
