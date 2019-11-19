

generic = (val) ->
  genericButton = (context) ->
    ui = $.summernote.ui
    button = ui.button(
      contents: '<i >' + val + '</i>'
      click: ->
        context.invoke 'editor.insertText', '{' + val + '}'
    )
    return button.render()




summernote_custom = ->
  val = $('input[id="document_variables"').val()
  toolbarCustom = [
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
  ]
  gbtn = new Array
  gButtons = new Array
  if val != undefined
    val = val.replace(/=>/g, ':')
    obj = JSON.parse(val)
    if obj != '{}'
      count = 0
      obj['cpf'] = 'cpf'
      $.each obj, (o, value) ->
        gButtons.push generic(value)
        gbtn[value] = gButtons[count]
        toolbarCustom.push(['generic', [value]],)
        count++
  $('[data-provider="summernote"]').each ->
    $(this).summernote
      height: 500
      fontSizes: ['8', '9', '10', '11', '12', '14', '18', '24', '30', '36', '42', '48', '54', '60',
        '64', '82', '150']
      toolbar: toolbarCustom
      buttons: gbtn
  $('div').removeClass('card-header').addClass('panel-heading')

$(document).on 'turbolinks:load', ->
  count = 0
  $('#plus_variable_json').on 'click', ->
    input = "<div id='div_variable_json_" + count + "' class='row'>
      <div class='col'>
        <div class='form-group string optional document_variable_json'><label class='form-control-label string optional' for='variable_json_0'>Variável</label><input class='form-control string optional' id='variable_json_" + count + "' type='text' name='document[variable_json]'></div>
      </div>
      <div class='col-2 pt-5 mt-1'>
        <a id='remove_variable_json' data='" + count + "' class='remove_variable_json btn btn-secondary'><i class='fe fe-trash'></i></a>
      </div>
    </div>"
    count++
    $('#variables_json').append input

  $(document).on 'click', '.remove_variable_json', (e) ->
    e.preventDefault()
    $(this).parent().parent().remove()
    return

  $('#close_modal').on 'click', ->
    summernote_custom()


  $('#save_variables').on 'click', ->
    inputs = $('#variables_json').find('input')
    json = '{'
    c = 0
    inputs.each ->
      json += '"' + @value + '"' + ':' + '"' + @value + '"'
      if c < inputs.length - 1
        json += ','
      c++
    json += '}'
    $('#document_variables').val(json)
    $('[data-provider="summernote"]').each ->
      $(this).summernote('destroy')
    summernote_custom()

  $('#modal_variables').modal()
  val = $('input[id="document_variables"').val()
  if val != undefined
    val = val.replace(/=>/g, ':')
    obj = JSON.parse(val)
    if obj != '{}'
      $.each obj, (o, value) ->
        input = "<div id='div_variable_json_" + count + "' class='row'>
            <div class='col'>
              <div class='form-group string optional document_variable_json'><label class='form-control-label string optional' for='variable_json_0'>Variable json</label><input value='" + value + "' class='form-control string optional' id='variable_json_" + count + "' type='text' name='document[variable_json]'></div>
            </div>
            <div class='col-2 pt-5 mt-1'>
              <a id='remove_variable_json' data='" + count + "' class='remove_variable_json btn btn-secondary'><i class='fe fe-trash'></i></a>
            </div>
            </div>"
        count++
        $('#variables_json').append input

  experiences = $('#document_users')

  experiences.on 'cocoon:after-insert', (e, added_el) ->
    added_el.find("select").first().focus();
    $('select').selectize()
  # COMENTÁRIO: Coloca o foco do cursor no primeiro input do novo objeto

  experiences.on 'cocoon:before-remove', (e, el_to_remove) ->
    $(this).data('remove-timeout', 1000)
    el_to_remove.fadeOut(1000)
