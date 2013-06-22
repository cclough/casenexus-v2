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

  def casecounts(user)
    count_int = content_tag :span, user.cases.count.to_s, style: "font-weight:bolder;"
    count_ext = content_tag :span, "+" + user.cases_external.to_s, style: "font-weight:lighter;"
    count_int + count_ext
  end

  def sortable(column, title)
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction, :page => nil), { :class => css_class }
  end

  def filterable_books(btype, title)
    if btype == params[:btype]
      link_to title, params.merge(btype: btype, page: 1), class: "btn btn-inverse active"
    elsif !params[:btype] && (title == "All")
      link_to title, params.merge(btype: btype, page: 1), class: "btn btn-inverse active"
    else
      link_to title, params.merge(btype: btype, page: 1), class: "btn btn-inverse"
    end
  end

  def pageable_books(number)
    if number == params[:per_page]
      link_to number, params.merge(per_page: number, page: 1), class: "btn btn-inverse active"
    elsif !params[:per_page] && (number == 10)
      link_to number, params.merge(per_page: number, page: 1), class: "btn btn-inverse active"
    else
      link_to number, params.merge(per_page: number, page: 1), class: "btn btn-inverse"
    end   
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

  def timezone_difference(user1, user2)
    
    time1 = Time.zone.now.in_time_zone(user1.time_zone)
    time2 = Time.zone.now.in_time_zone(user2.time_zone)

    time_difference = (time2.utc_offset - time1.utc_offset) / 1.hour
    
    if time_difference < 0
      # .abs makes it positive
      pluralize(time_difference.abs, "hour") + " behind"
    elsif time_difference > 0
      pluralize(time_difference, "hour") + " ahead"
    elsif time_difference = 0
      "Same Time Zone"
    end

  end

  def book_difficulty_in_words(num)
    case num
    when 1
      content_tag :span, "Novice", class: "application_bootstrap_green"
    when 2
      content_tag :span, "Intermediate", class: "application_bootstrap_yellow"
    when 3
      content_tag :span, "Advanced", class: "application_bootstrap_red"
    end
  end

end