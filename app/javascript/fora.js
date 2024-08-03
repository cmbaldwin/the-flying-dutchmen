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

  // Fade .toast.notice elements
  const toastElements = document.querySelectorAll('.toast.notice');
  toastElements.forEach(toastElement => {
    // Initialize the toast using Bootstrap's Toast class
    const toast = new bootstrap.Toast(toastElement);
    // Show the toast
    toast.show();
    // Set a timeout to hide the toast after 5 seconds
    setTimeout(() => {
      toast.hide();
    }, 5000);
  });
});
