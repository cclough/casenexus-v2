module ApplicationHelper

  # Returns the full title on a per-page basis
  def full_title(page_title)
    base_title = 'casenexus.com'
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end


  def sortable(column, title)
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction, :page => nil), { :class => css_class }
  end


  def filterable(ntype, title)
    link_to title, params.merge(ntype: ntype), class: "btn btn-mini"
  end


  def avatar_for(user, type)

    case type
      when "icon"
        avatar_url = "avatars/avatar_" + user.level + ".png"
        avatar_alt = user.name + " has done " + user.cases.count.to_s + " cases"
        link_to image_tag(avatar_url, alt: avatar_alt, class: "application_avatar_icon", "data-original-title"=>"Go to " + user.name + "'s profile", rel: "tooltip", "data-placement"=>"bottom"), "/map?user_id=" + user.id.to_s

      when "icon_inert"
        avatar_url = "avatars/avatar_" + user.level + ".png"
        avatar_alt = user.name + " has done " + user.cases.count.to_s + " cases"
        image_tag(avatar_url, alt: avatar_alt, class: "application_avatar_icon", "data-original-title" => user.name + " has done " + user.cases.count.to_s + " cases", rel: "tooltip", "data-placement"=>"right")

    end
  end

end