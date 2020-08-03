// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery/dist/jquery.min
//= require turbolinks
//= require bootstrap/dist/js/bootstrap.min
//= require bootstrap-select/dist/js/bootstrap-select.min.js
//= require admin-lte/dist/js/adminlte.js
//= require plugins/jquery.maskMoney.min
//= require moment
//= require bootstrap-datetimepicker
//= require jquery.mask
//= require_tree .


// Corrigi o resize do active admin executado pelo turbolinks
document.addEventListener('turbolinks:load', () => $(window).trigger('resize'));

// Active menu items
$(document).ready(function () {
  var url = window.location;
  // for sidebar menu entirely but not cover treeview
  $('ul.sidebar-menu a').filter(function () {
    return this.href == url;
  }).parent().addClass('active');

  // for treeview
  $('ul.treeview-menu a').filter(function () {
    return this.href == url;
  }).parentsUntil(".sidebar-menu > .treeview-menu").addClass('active');

});

$(document).ready(function () {
  $(function () {
    $('.currency').maskMoney({
      thousands: '.',
      decimal: ',',
      prefix: 'R$ '
    }).maskMoney('mask');

    $('.phone_with_ddd').mask('(00) 00000-0000');
    $('.cpf').mask('000.000.000-00', { reverse: false });
  });

  $('.currency').each(function () {
    if (!$(this).val().match(/,/g)) {
      $(this).val($(this).val().replace(".", ","));
    }
  })
})
