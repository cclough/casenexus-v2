module UsersHelper

  def avatar_for(user, type, case_count)

    case type
      when "icon"
        avatar_colour = "orange"
        avatar_url = "avatars/avatar_" + avatar_colour + ".png"
        avatar_alt = user.name + " has done " + user.case_count.to_s + " cases"
        image_tag(avatar_url, alt: avatar_alt)

      when "chevron"
        avatar_colour = "1"
        avatar_style = "background-image: url(/assets/chevrons/chevron_" + avatar_colour + ".png);"
        content_tag :div, style: avatar_style, class: 'application_chevron' do
          content_tag(:div, case_count) + content_tag(:div, 'cases', class: 'application_chevron_text')
        end
    end
  end

end
