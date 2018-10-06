SGE.search = (el) ->
  base_url = $(el).data('url')
  $(el).keypress (e) ->
    url = base_url + "/" + $(el).val()
    keycode = e.keyCode || e.which
    console.log keycode
    if keycode == 13
      console.log keycode
      window.location.assign(url)