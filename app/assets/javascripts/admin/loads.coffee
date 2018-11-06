$(document).on "turbolinks:load", ->
  $('[data-toggle="tooltip"]').tooltip()
  SGE.search('#users_search_input')