module UsersHelper

	def avatar_for(user)

		case user.casecount
		when 0..4 then avatar_colour = "grey"
		when 5..9 then avatar_colour = "yellow"
		when 10..19 then avatar_colour = "orange"
		when 20..29 then avatar_colour = "red"
		when 30..39 then avatar_colour = "green"
		when 40..49 then avatar_colour = "blue"
		when 50..1000 then avatar_colour = "purple"
		end

		avatar_url = "avatars/avatar_" + avatar_colour + ".png"

		avatar_alt = user.name + " has done " + user.casecount.to_s + " cases"

		image_tag(avatar_url, alt: avatar_alt)
	
	end

end
