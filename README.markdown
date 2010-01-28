has_layout
==========

has_layout is plugin that allow to choose the layout with options like
`:except`, `:only`, `:if` and `:unless`.

Usage
-----

Install the plugin with

	script/plugin install git://github.com/fnando/has_layout.git

Add the method call `has_layout` to your controller.

	class PagesController < ApplicationController
	  has_layout 'site'
	  has_layout 'site', :only => %w(faq feedback)
	  has_layout 'custom', :except => %w(faq feedback)
	  has_layout 'admin', :if => proc { current_user.admin? }
	  has_layout 'public', :unless => proc { !current_user.admin? }
	end

When rendering a HTML format (`params[:format]`) in a XHR request, no layout is rendered. You can override this behavior by setting `render :layout => "layout"` in your action.

Maintainer
----------

* Nando Vieira (<http://simplesideias.com.br>)

License:
--------

(The MIT License)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.