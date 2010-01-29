require "has_layout"

config.after_initialize do
  ApplicationController.class_eval do
    extend SimplesIdeias::Layout::ClassMethods
    include SimplesIdeias::Layout::InstanceMethods

    cattr_accessor :layout_options
    layout :choose_layout
  end
end
