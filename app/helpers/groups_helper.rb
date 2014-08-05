module GroupsHelper
	def group_privacy_icon(privacy)
		content_tag(:i, "", class: privacy_icon_class(privacy))
	end

	private
	def privacy_icon_class(privacy)
		case privacy
		when "open"
			"fi-web"
		when "close"
			"fi-lock"
		when "secret"
			"fi-shield"
		end
	end
end
