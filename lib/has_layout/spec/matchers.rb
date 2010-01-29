Spec::Matchers.define :render_layout do |expected_layout|
  expected_layout = "layouts/#{expected_layout}"
  normalize_layout_name = proc {|n| n.to_s.gsub(/^layouts\//, "") }

  match do |response|
    response.layout == expected_layout
  end

  failure_message_for_should  do |response|
    "expected #{normalize_layout_name.call(expected_layout).inspect} layout to be rendered but was #{normalize_layout_name.call(response.layout).inspect}"
  end

  failure_message_for_should_not  do |response|
    "expected #{normalize_layout_name.call(expected_layout).inspect} layout not to be rendered"
  end
end
