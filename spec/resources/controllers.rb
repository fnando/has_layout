class SampleController < ApplicationController
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

class MyController < ApplicationController
  def index
  end
end

class FooController < ApplicationController
  def index
  end
end