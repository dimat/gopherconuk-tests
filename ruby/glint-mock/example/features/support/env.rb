require 'glint-mock'

at_exit do
	Glint::Mock::shutdown_all
end

After do
	Glint::Mock::shutdown_all
end
