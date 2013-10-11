

$(document).ready ->

  # Tag Select click
  $(".books_index_form_fitlers_tag_selector_item").click ->
    tag_id = $(this).data "tag_id"

    $("#books_filter_tag").val tag_id
    $(".books_index_form_fitlers_tag_selector_item").removeClass "books_index_form_fitlers_tag_selector_item_active"
    $(this).addClass "books_index_form_fitlers_tag_selector_item_active"


  # Submit form on select from selects
  $(".books_index_books_form_select").change ->
    $("#books_index_books_form").submit()


  # Schedule button
  $(".books_index_books_item_schedule_button").click ->

    book_id = $(this).data("book_id")

    window.modal_event_new_show(null,book_id)

  # Set rate, for book#show
  $(".books_rating_set").raty
    targetType   : 'number'
    targetKeep   : true
    target: "#books_rating_set_field"




  # WHEN I PUT FUNCTIONS ABOVE, BELOW PRIME RATY IT DOESN"T WORK - SOMETHING BROKEN?

  window.application_raty_prime()



  # Arrows for the home page and help
  if $(".application_filtergroup_choicenav").size() > 0

    window.ChoiceNav =
      init: ->

        $("li[href*=#]").click (e) ->
          e.preventDefault()
          filter_name = $(this).closest(".application_filtergroup_choicenav").attr "data-filter_name"
          window.ChoiceNav.goTo $(this).attr("href").split("#")[1], filter_name if $(this).attr("href").split("#")[1]
        # @goTo "1"
      goTo: (page, filter_name) ->
        filter_name_complete = "#application_filtergroup_choicenav_" + filter_name
        nav_item = $(filter_name_complete + " nav ul li[href=#" + page + "]")

        btype = $(nav_item).data "btype"
        $("#books_filter_" + filter_name).val btype

        window.ChoiceNav.centerArrow nav_item, filter_name_complete
        window.ChoiceNav.growLine nav_item, filter_name_complete
      
      centerArrow: (nav_item, filter_name) ->
        left_margin = (nav_item.position().left + nav_item.width()/2) + 22 - (nav_item.width() / 2)
        $(filter_name + " nav .arrow").animate
          left: left_margin
        , 100, ->
          $(this).show()

      growLine: (nav_item, filter_name) ->
        left_margin = (nav_item.position().left + nav_item.width()/2) - (nav_item.width() / 2)
        $(filter_name + " nav .application_filtergroup_choicenav_follower_line").animate
          width: left_margin
        , 100, ->
          $(this).show()  

  window.ChoiceNav.init()
