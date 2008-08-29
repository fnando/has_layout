class PostsController < ApplicationController
  has_layout 'special', :only => %w(index)
  has_layout 'admin',   :only => :edit, :if => proc{|c| c.action_name == 'edit' }
  has_layout 'site',    :except => %w(index), :unless => :action_name_is_follow?
  
  def index
  end
  
  def edit
  end
  
  def show
  end
  
  def follow
  end
  
  def comments
  end
  
  private
    def action_name_is_follow?
      action_name != 'follow'
    end
end
