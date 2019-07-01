$(document).on("turbolinks:load", () => SGE.enterToSubmitSearch());

SGE.enterToSubmitSearch = function() {
  el = 'input.enter-to-submit-search'
  const base_url = $(el).data('url');
  return $(el).keypress(function(e) {
    const url = base_url + "/" + $(el).val();
    const keycode = e.keyCode || e.which;
    if (keycode === 13) {
      return window.location.assign(url);
    }
  });
};
