require "has_layout"

config.to_prepare do
  ApplicationController.send :include, SimplesIdeias::Layout
end
