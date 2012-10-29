module UsersHelper

  def avatar_for(user, type, case_count)

    case type
      when "icon"

        case user.case_count
        when 0..9 then avatar_num = 0
        when 10..19 then avatar_num = 1
        when 20..29 then avatar_num = 2
        when 30..39 then avatar_num = 3
        when 40..49 then avatar_num = 4
        when 50..1000 then avatar_num = 5
        end

        avatar_url = "avatars/avatar_" + avatar_num.to_s + ".png"
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
