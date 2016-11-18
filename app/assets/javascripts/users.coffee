ready = ->
  $('select#user_country').change (event) ->
    select_wrapper = $('#user_city_wrapper')

    $('select', select_wrapper).attr('disabled', true)

    country = $(this).val()
    
    url = "/users/{id}/subregion_options?parent_region=#{country}"
    select_wrapper.load(url)
$(document).ready(ready)
$(document).on('page:load', ready)

ready = ->
  $('select#q_country_in').change (event) ->
    select_wrapper = $('#user_city_wrapper')

    $('select', select_wrapper).attr('disabled', true)

    country = $(this).val()
    url = "/users/{id}/city_search?parent_region=#{country}"
    select_wrapper.load(url)
$(document).ready(ready)
$(document).on('page:load', ready)