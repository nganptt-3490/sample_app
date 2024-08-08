document.addEventListener('turbo:load', function() {
  I18n.locale = document.querySelector('body').getAttribute('data-locale');
  let account = document.querySelector('#account');
  account.addEventListener('click', function(event) {
    event.preventDefault();
    let menu = document.querySelector('#dropdown-menu');
    menu.classList.toggle('active');
  });
});
