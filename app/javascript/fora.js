document.addEventListener("turbo:load", () => {
  document.addEventListener('click', function (event) {
    const top_link = event.target.closest('[data-top]');
    if (top_link) {
      document.body.scrollTop = 0;
      document.documentElement.scrollTop = 0;
      event.preventDefault();
      event.stopPropagation();
    }
  });
});