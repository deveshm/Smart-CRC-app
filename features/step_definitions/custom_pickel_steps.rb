Then /^#{capture_model} should exist with expanded #{capture_fields}$/ do |model_name,fields|
	find_model!(model_name,StringExpander.expand_string(fields))
end
