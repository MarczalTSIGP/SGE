document.addEventListener('turbolinks:load', () => {
  SGE.sidebarMenuCollapse();
});

SGE.sidebarMenuCollapse = () => {
  $('[data-toggle="collapse"]').click(() => {
    $('html, body').animate({ scrollTop: 0 }, 'slow');
  });
};
