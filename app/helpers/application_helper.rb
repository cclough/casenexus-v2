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

  def avatar_for(user, options = {})

    options[:size] ||= "small"
    options[:link] ||= 1

    avatar_url = "universities/" + user.university.image
    

    if options[:link] === 1
      avatar_alt = "Jump to " + user.username + "'s profile"
      link_to image_tag(avatar_url, alt: avatar_alt, class: "application_userimage_" + options[:size], "data-original-title" => avatar_alt, rel: "tooltip", "data-placement"=>"bottom"), "/map?user_id=" + user.id.to_s
    else
      avatar_alt = user.username + " is a student of " + user.university.name
      image_tag(avatar_url, alt: avatar_alt, class: "application_userimage_" + options[:size], "data-original-title" => avatar_alt, rel: "tooltip", "data-placement"=>"bottom")
    end  
  end

  def university_logo_for(university, options = {})

    options[:size] ||= "small"

    university_url = "universities/" + university.image
    
    university_alt = university.name
    image_tag(university_url, alt: university_alt, class: "application_userimage_" + options[:size], "data-original-title" => university_alt, rel: "tooltip", "data-placement"=>"bottom")
  end

  # Render will_paginate with bootstrap pagination css - https://gist.github.com/robacarp/1562185
  def paginate *params
    params[1] = {} if params[1].nil?
    params[1][:renderer] = BootstrapPaginationHelper::LinkRenderer
    params[1][:class] ||= 'pagination pagination-centered small'
    params[1][:inner_window] ||= 2
    params[1][:outer_window] ||= 2
    will_paginate *params
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

  def filterable_analysis(view,title)
    if view == @view
      link_to title, params.merge(view: view), class: "btn btn-primary active"
    elsif !params[:view] && (view == "table")
      link_to title, params.merge(view: view), class: "btn btn-primary active"
    else
      link_to title, params.merge(view: view), class: "btn btn-primary"
    end
  end

  def filterable_books(btype, title)
    if btype == params[:btype]
      link_to title, params.merge(btype: btype, page: 1), class: "btn btn-primary active"
    elsif !params[:btype] && (title == "All")
      link_to title, params.merge(btype: btype, page: 1), class: "btn btn-primary active"
    else
      link_to title, params.merge(btype: btype, page: 1), class: "btn btn-primary"
    end
  end

  def pageable_books(number)
    if number == params[:per_page]
      link_to number, params.merge(per_page: number, page: 1), class: "btn btn-primary active"
    elsif !params[:per_page] && (number == "10")
      link_to number, params.merge(per_page: number, page: 1), class: "btn btn-primary active"
    else
      link_to number, params.merge(per_page: number, page: 1), class: "btn btn-primary"
    end   
  end


  def colorcoded_cell(num_to_code, value)
    if (num_to_code > 0)
      content_tag :td, value, class: "application_colorcode_green"
    else
      content_tag :td, value, class: "application_colorcode_red"
    end      
  end

  def recommendation_cell(growth, diff_from_av)

    if (growth < 0) && (diff_from_av < 0)
      content_tag :td, "Needs work", class: "application_colorcode_red"
    else
      content_tag :td, "-", class: "application_colorcode_green"
    end
  end
  


  def timezone_difference(user1, user2)
    
    time1 = Time.zone.now.in_time_zone(user1.time_zone)
    time2 = Time.zone.now.in_time_zone(user2.time_zone)

    time_difference = (time2.utc_offset - time1.utc_offset) / 1.hour
    
    if time_difference < 0
      # .abs makes it positive
      pluralize(time_difference.abs, "hour") + " behind you"
    elsif time_difference > 0
      pluralize(time_difference, "hour") + " ahead of you"
    elsif time_difference == 0
      "Same time zone as you"
    end

  end

  def books_difficulty_stamp(book)

    num = book.difficulty

    case num
    when 1
      content_tag :div, "Novice", class: "books_index_books_item_difficulty application_bootstrap_alert_green"
    when 2
      content_tag :div, "Intermediate", class: "books_index_books_item_difficulty application_bootstrap_alert_blue"
    when 3
      content_tag :div, "Advanced", class: "books_index_books_item_difficulty application_bootstrap_alert_red"
    end
  end

  def books_small_difficulty_stamp(book)
    num = book.difficulty

    case num
    when 1
      content_tag :div, "Novice", class: "books_show_small_difficulty application_bootstrap_alert_green"
    when 2
      content_tag :div, "Intermediate", class: "books_show_small_difficulty application_bootstrap_alert_blue"
    when 3
      content_tag :div, "Advanced", class: "books_show_small_difficulty application_bootstrap_alert_red"
    end
  end



  def books_difficulty_triangle(book)

    num = book.difficulty

    case num
    when 1
      content_tag :div,"" , class: "books_index_books_item_difficulty_triangle novice"
    when 2
      content_tag :div,"" , class: "books_index_books_item_difficulty_triangle intermediate"
    when 3
      content_tag :div,"" , class: "books_index_books_item_difficulty_triangle advanced"
    end
  end


  def online_user_count
      count = pluralize(User.online_now.count,"user")
      count_tag = content_tag :span, count#, class: "application_colorcode_green"
      count_tag + " online"
  end




  def application_taglist(tags)
    max = 0
    tags.each do |t|
      if t.count.to_i > max
        max = t.count.to_i
      end 
    end
    tags.each do |tag|
      yield(tag, tag.count)
    end
  end 

  def calendar_ics_url
    host = Rails.env == 'production' ? 'www.casenexus.com' : 'localhost:3000'
    calendar_ics_url = "webcal://" + host + "/events/ics"
  end

  def questions_addcomment_link(commentable_id, commentable_type)
    link = content_tag "span", "Add comment", "data-commentable_id"=>commentable_id, 
          "data-commentable_type"=> commentable_type,
          class: "questions_comment_add_button"
    link
  end



  def users_skill_triangle_for(user)

    num = user.cases.count

    # case num
    # when 1..3
      content_tag :div,"" , class: "map_index_users_item_skill_triangle novice"
    # when 3..8
    #   content_tag :div,"" , class: "map_index_users_item_skill_triangle intermediate"
    # # when 8..11
    #   content_tag :div,"" , class: "map_index_users_item_skill_triangle advanced"
    # # end
  end
end