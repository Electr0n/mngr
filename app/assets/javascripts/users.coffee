ready = ->
  $('select#user_country').change (event) ->
    select_wrapper = $('#user_city_wrapper')

    $('select', select_wrapper).attr('disabled', true)

    country = $(this).val()
    
    url = "/users/{id}/subregion_options?parent_region=#{country}"
    select_wrapper.load(url)
$(document).ready(ready)
$(document).on('page:load', ready)

$(document).ready ->
  $('select#country').change ->
    x = $(@).find(':selected').text().toLowerCase().replace(' ', '-')
    options = _.map $('#cities').data(x), (city) ->
      code = city[0]
      name = city[1]
      option = $('<option></option>').attr("value", code).text(name)
    $('#city').empty()
    _.each options, (el) ->
      $('#city').append(el)
