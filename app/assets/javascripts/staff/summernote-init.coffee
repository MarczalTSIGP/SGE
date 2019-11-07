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

$(document).on 'turbolinks:load', ->
  $('[data-provider="summernote"]').each ->
    $(this).summernote
      height: 200
      toolbar: toolbarCustom

  $('div').removeClass('card-header').addClass('panel-heading')
