module UsersHelper

	def avatar_for(user, type, casecount)

		case type
		when "icon"

			# case user.casecount
			# when 0..9 then avatar_colour = "grey"
			# when 10..19 then avatar_colour = "blue"
			# when 20..29 then avatar_colour = "yellow"
			# when 30..49 then avatar_colour = "orange"
			# when 50..1000 then avatar_colour = "purple"
			# end

			avatar_colour = "orange"
			
			avatar_url = "avatars/avatar_" + avatar_colour + ".png"

			avatar_alt = user.name + " has done " + user.casecount.to_s + " cases"

			image_tag(avatar_url, alt: avatar_alt)

		when "chevron"

			avatar_colour = "1"
			
			avatar_style = "background-image: url(/assets/chevrons/chevron_" + avatar_colour + ".png);"

			content_tag :div, style: avatar_style, class: 'application_chevron' do
				content_tag(:div, casecount) + content_tag(:div, 'cases', class: 'application_chevron_text')
			end
		end
	end

end
