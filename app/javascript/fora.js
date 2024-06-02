document.addEventListener("turbo:load", function () {

  // https://stackoverflow.com/questions/63328755/how-do-i-make-a-javascript-function-available-globally-in-rails-6-with-webpack
  document.querySelectorAll('[data-top]').forEach(function (top_link) {
    top_link.addEventListener('click', function (event) {
      let name = top_link.dataset['top']
      document.body.scrollTop = 0;
      document.documentElement.scrollTop = 0;
      event.preventDefault();
      event.stopPropagation();
      return false;
    });
  });

});