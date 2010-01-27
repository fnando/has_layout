ActionController::Base.class_eval do
  extend SimplesIdeias::Layout::ClassMethods
  include SimplesIdeias::Layout::InstanceMethods

  cattr_accessor :has_layout_options

  def self.inherited(child)
    super
    child.has_layout_options = []
    child.before_filter :choose_layout
  end
end
