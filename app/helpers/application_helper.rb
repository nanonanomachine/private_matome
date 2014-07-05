module ApplicationHelper
	# app/helpers/application_helper.rb
	def shallow_args(parent, child)
		child.try(:new_record?) ? [parent, child] : child
	end
end
