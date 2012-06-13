// -------------- APPLICATION.JS --------------
// Aplication wide javascript

// -------------- JQUERY START --------------
$(document).ready(function () {

  // Make colapsing things collapse
  $(".collapse").collapse();
  
  // Popover
  $('.help').popover();
  
  // Text Area
  $('textarea').redactor({
     toolbar    : 'noodall',
     autoresize :  true
  });
  
}); //eo: Document Ready

