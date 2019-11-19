$(document).on('turbolinks:load', function () {

    $("#preview-button").click(function (event) {
        event.preventDefault();

        user_documents()

        $('#myModalPreview').modal('show');
    });


    function myFunction(val, tag) {
        return "<" + tag + " class='text-center text-capitalize'>" + val + "</" + tag + ">"
    };

    function user_documents() {
        var description = $('#document_front').val();
        var activity = $('#document_back').val();

        var select = new Array;
        var input = new Array;
        var html = "";

        console.log('aquiiiiiiiiiiiiiiiiii')

        $('#document_description_view').html(description)
        $('#document_activity_view').html(activity)


    };

});