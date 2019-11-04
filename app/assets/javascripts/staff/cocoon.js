$(document).on('turbolinks:load', function () {
    if ($("select option:selected").length == 0) {
        $('a[data-associations="document_users"]').trigger('click');
    }
});