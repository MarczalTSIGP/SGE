path = "C:\\fakepath\\"
$(document).on 'turbolinks:load', ->
  $('input[id="csv"]').bind 'change', ->
    $('#label-file').text($(this).val().replace(path, ''))