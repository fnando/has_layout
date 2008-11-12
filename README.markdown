has_layout
==========

has_layout is plugin that allow to choose the layout with options like
`:except`, `:only`, `:if` and `:unless`.

Instalation
-----------

1) Install the plugin with `script/plugin install git://github.com/fnando/has_layout.git`

Usage
-----

1) Add the method call `has_layout` to your controller.

	class PagesController < ApplicationController
	  has_layout 'site', :only => %w(faq feedback)
	  has_layout 'custom', :except => %w(faq feedback)
	  has_layout 'admin', :if => proc { current_user.admin? }
	  has_layout 'public', :unless => proc { !current_user.admin? }
	end

Copyright (c) 2008 Nando Vieira, released under the MIT license