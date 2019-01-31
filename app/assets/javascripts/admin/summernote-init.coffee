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
        ['aux', ['cpf', 'name']]
      ]
      buttons:
        cpf: CPFButton
        name: NameButton

  $('div').removeClass('card-header').addClass('panel-heading')


