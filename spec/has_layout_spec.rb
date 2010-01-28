require File.dirname(__FILE__) + "/spec_helper"

class SampleController < ActionController::Base
  def index
  end

  def edit
  end

  def remove
  end

  private
    def executing_remove_action
      self.action_name == "remove"
    end
end

class MyController < ActionController::Base
  def index
  end
end

class FooController < ActionController::Base
  def index
  end
end

describe "Has Layout", :type => :controller do
  controller_name :sample

  before do
    ActionController::Base.prepend_view_path File.dirname(__FILE__) + "/resources/views"
    ActionController::Base.layout_options = []
  end

  context "no options" do
    before do
      SampleController.has_layout "general"
    end

    specify "GET /index should render the general layout" do
      get :index
      response.should render_layout("general")
    end

    specify "GET /edit should render the general layout" do
      get :edit
      response.should render_layout("general")
    end

    specify "GET /remove should render the general layout" do
      get :remove
      response.should render_layout("general")
    end
  end

  context ":only option" do
    before do
      SampleController.has_layout "general", :only => "edit"
    end

    specify "GET /index should not render the general layout" do
      get :index
      response.should_not render_layout("general")
    end

    specify "GET /edit should render the general layout" do
      get :edit
      response.should render_layout("general")
    end

    specify "GET /remove should not render the general layout" do
      get :remove
      response.should_not render_layout("general")
    end
  end

  context ":except option" do
    before do
      SampleController.has_layout "general", :except => "edit"
    end

    specify "GET /index should render the general layout" do
      get :index
      response.should render_layout("general")
    end

    specify "GET /edit should not render the general layout" do
      get :edit
      response.should_not render_layout("general")
    end

    specify "GET /remove should render the general layout" do
      get :remove
      response.should render_layout("general")
    end
  end

  context ":if option as method" do
    before do
      SampleController.has_layout "general", :if => :executing_remove_action
    end

    specify "GET /index should not render the general layout" do
      get :index
      response.should_not render_layout("general")
    end

    specify "GET /edit should not render the general layout" do
      get :edit
      response.should_not render_layout("general")
    end

    specify "GET /remove should render the general layout" do
      get :remove
      response.should render_layout("general")
    end
  end

  context ":if option as proc" do
    before do
      SampleController.has_layout "general", :if => proc { executing_remove_action }
    end

    specify "GET /index should not render the general layout" do
      get :index
      response.should_not render_layout("general")
    end

    specify "GET /edit should not render the general layout" do
      get :edit
      response.should_not render_layout("general")
    end

    specify "GET /remove should render the general layout" do
      get :remove
      response.should render_layout("general")
    end
  end

  context ":unless option as method" do
    before do
      SampleController.has_layout "general", :unless => :executing_remove_action
    end

    specify "GET /index should render the general layout" do
      get :index
      response.should render_layout("general")
    end

    specify "GET /edit should render the general layout" do
      get :edit
      response.should render_layout("general")
    end

    specify "GET /remove should not render the general layout" do
      get :remove
      response.should_not render_layout("general")
    end
  end

  context ":unless option as proc" do
    before do
      SampleController.has_layout "general", :unless => proc { executing_remove_action }
    end

    specify "GET /index should render the general layout" do
      get :index
      response.should render_layout("general")
    end

    specify "GET /edit should render the general layout" do
      get :edit
      response.should render_layout("general")
    end

    specify "GET /remove should not render the general layout" do
      get :remove
      response.should_not render_layout("general")
    end
  end

  context "multiple rules" do
    before do
      SampleController.has_layout "general", :only => %w(edit index)
      SampleController.has_layout "custom", :if => proc { action_name == "remove" }
    end

    specify "GET /index should render the general layout" do
      get :index
      response.should render_layout("general")
    end

    specify "GET /edit should render the general layout" do
      get :edit
      response.should render_layout("general")
    end

    specify "GET /remove should render the custom layout" do
      get :remove
      response.should render_layout("custom")
    end
  end

  context "controller name with format" do
    controller_name :my

    it "should render 'my'" do
      get :index
      response.should render_layout("my")
    end
  end

  context "controller name without format" do
    controller_name :foo

    it "should render 'foo'" do
      get :index
      response.should render_layout("foo")
    end
  end

  context "XHR requests" do
    specify "GET /index should not render layout when doing a XHR request" do
      xhr :get, :index
      response.layout.should be_nil
    end
  end

  context "original method" do
    before do
      SampleController.layout "general"
    end

    it "should use general layout" do
      get :index
      response.should render_layout("general")
    end
  end
end
