import I18n from 'i18n-js';
document.addEventListener('turbo:load', function() {
  I18n.locale = document.querySelector('body').getAttribute('data-locale');
  document.addEventListener('change', function(event) {
    let image_upload = document.querySelector('#micropost_image');
    const size_in_megabytes = image_upload.files[0].size/1024/1024;
    if (size_in_megabytes > Settings.digits.digit_5) {
      alert(I18n.t('microposts.max_5mb'));
      image_upload.value = '';
    }
  });
});
