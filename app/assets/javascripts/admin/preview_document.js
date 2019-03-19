$(document).on('turbolinks:load', function () {

    $("#preview-button").click(function (event) {
        event.preventDefault();

        if ($('input[name="document[kind]"]:checked').val() == 'declaration') {
            $('#document_kind').html("declaração")
        } else {
            $('#document_kind').html("certificado")
        }

        $('#document_description_view').html($('#document_description').val());
        $('#document_activity_view').html($('#document_activity').val());
        var select = new Array;
        var input = new Array;
        var html = "";
        var classes = "class='text-center text-capitalize'";
        $("select option:selected").each(function (option) {
            select[option] = "<h4 " + classes + ">" + $(this).text() + "</h4>"
        });

        $('input[name*="[function]"]').each(function (val) {
            input[val] = "<h6 " + classes + ">" + $(this).val() + "</h6>"
        });

        for (i = 0; i < input.length; i++) {
            html += select[i] + input[i] + "<br>"
        }

        $('#document_users').html(html);
        $('#myModal').modal('show');
    });
    if ($("select option:selected").length == 0) {
        $('a[data-associations="users_documents"]').trigger('click');
    }
});