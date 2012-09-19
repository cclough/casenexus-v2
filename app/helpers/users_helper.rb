module UsersHelper


	# user avatar/icon function
	def avatar_for(user)

		# categorize number of cases done by user - DOESNT WORK!
		if user.casecount < 10
			avatar_colour = "white"
		elsif [user.casecount > 9, user.casecount < 25]
			avatar_colour = "yellow"
		elsif [user.casecount > 24, user.casecount < 50]
			avatar_colour = "green"
		elsif user.casecount > 50
			avatar_colour = "purple"
		end

		# build asset url
		avatar_url = "avatars/user_" + avatar_colour + ".png"

		# return icon
		alt = user.name + " has done " + user.casecount.to_s + " cases"
		image_tag(avatar_url, alt: alt)
	
	end

end
