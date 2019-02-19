CPFButton = (context) ->
  ui = $.summernote.ui
  button = ui.button(
    contents: '<i >CPF</i>'
    click: ->
      context.invoke 'editor.insertText', '#{cpf}'
  )
  button.render()
NameButton = (context) ->
  ui = $.summernote.ui
  button = ui.button(
    contents: '<i>Nome</i>'
    click: ->
      context.invoke 'editor.insertText', '#{nome}'
  )
  button.render()
TimeActivityButton = (context) ->
  counter = 0
  ui = $.summernote.ui
  button = ui.button(
    contents: '<i>Hora</i>'
    click: ->
      counter++
      context.invoke 'editor.insertText', '#{hora_' + counter + '}'
  )
  button.render()
TotalHoursButton = (context) ->
  counter = 0
  ui = $.summernote.ui
  button = ui.button(
    contents: '<i>Total de Horas</i>'
    click: ->
      counter++
      context.invoke 'editor.insertText', '#{total_horas}'
  )
  button.render()

ActivityButton = (context) ->
  counter = 0
  ui = $.summernote.ui
  button = ui.button(
    contents: '<i>Atividade</i>'
    click: ->
      counter++
      context.invoke 'editor.insertText', '#{atividade_' + counter + '}'
  )
  button.render()


$(document).on 'turbolinks:load', ->
  $('[data-provider="summernote"]').each ->
    $(this).summernote
      toolbar: [
        ['style', ['style']],
        ['font', ['bold', 'italic', 'underline', 'clear']],
        ['fontname', ['fontname']],
        ['fontsize', ['fontsize']],
        ['color', ['color']],
        ['para', ['ul', 'ol', 'paragraph']],
        ['height', ['height']],
        ['table', ['table']],
        ['insert', ['link']],
        ['view', ['codeview']],
        ['help', ['help']],
        ['person', ['cpf', 'name']],
        ['activity', ['atividade', 'hora_atividade', 'total_horas']]
      ]
      buttons:
        cpf: CPFButton
        name: NameButton
        hora_atividade: TimeActivityButton
        atividade: ActivityButton
        total_horas: TotalHoursButton


  $('div').removeClass('card-header').addClass('panel-heading')



