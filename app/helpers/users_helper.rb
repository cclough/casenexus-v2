module UsersHelper

  def avatar_for(user, type)

    case type
      when "icon"
        avatar_url = "avatars/avatar_" + user.level + ".png"
        avatar_alt = user.name + " has done " + user.cases.count.to_s + " cases"
        image_tag(avatar_url, alt: avatar_alt)

      when "chevron"
        chevron_num = "1"
        chevron_style = "background-image: url(/assets/chevrons/chevron_" + chevron_num + ".png);"
        content_tag :div, style: chevron_style, class: 'application_chevron' do
          content_tag(:div, user.cases.count.to_s) + content_tag(:div, 'cases', class: 'application_chevron_text')
        end
    end
  end

end
