require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  def test_should_use_special_layout_with_only_option
    get :index
    assert_layout 'special'
  end
  
  def test_should_use_admin_layout_with_only_option_and_if_using_proc
    get :edit
    assert_layout 'admin'
  end
  
  def test_should_use_site_layout_with_except_option_and_unless_using_symbol
    get :follow
    assert_layout 'site'
  end
  
  def test_should_use_application_layout
    get :comments
    assert_layout 'application'
  end
  
  private
    def assert_layout(layout_name)
      assert_equal "layouts/#{layout_name}", @response.layout
    end
end
