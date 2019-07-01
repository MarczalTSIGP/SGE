$(document).on("turbolinks:load", () => SGE.enterToSubmitSearch());

SGE.enterToSubmitSearch = function() {
  const el = 'input.enter-to-submit-search';
  const btn = 'button.submit-search';
  const base_url = $(el).data('url');

  $(btn).click(function() {
    const url = base_url + '/' + $(el).val();
    return window.location.assign(url);
  });

  $(el).keypress(function(e) {
    const keycode = e.keyCode || e.which;
    if (keycode === 13) {
      const url = base_url + '/' + $(el).val();
      return window.location.assign(url);
    }
  });
};
