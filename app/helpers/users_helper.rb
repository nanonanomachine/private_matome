module UsersHelper
	 # return user image
	 def user_avatar_for(user, size)
	 	if user.avatar?
	 		image_tag(user.avatar.thumb.url, width: size, height: size)
	 	else
	 		gravatar_for(user,size)
	 	end
	 end
	
	 private
	 # return a Gravatar image of a certain user
	 def gravatar_for(user, size)
	 	gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
	 	gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
	    image_tag(gravatar_url, alt: user.email, class: "gravatar")
	end
end
