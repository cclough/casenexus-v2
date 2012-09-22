module UsersHelper

	def avatar_for(user)

		case user.casecount
		when 0..9 then avatar_colour = "orange"
		when 10..24 then avatar_colour = "orange"
		when 24..49 then avatar_colour = "orange"
		else avatar_colour = "orange"
		end

		avatar_url = "avatars/avatar_" + avatar_colour + ".png"

		avatar_alt = user.name + " has done " + user.casecount.to_s + " cases"

		image_tag(avatar_url, alt: avatar_alt)
	
	end

end
