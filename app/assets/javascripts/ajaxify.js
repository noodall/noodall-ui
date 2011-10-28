// Set a form to send via ajax and remove current errors
// usage:
//   ajaxifyForms('#new_subscriber')
function ajaxifyForms(selector) {
  $(selector).live('submit', function() {
    $(this).find('#errorExplanation, .success').slideUp('fast', function() { $(this).remove();});
    $.post($(this).attr('action'), $(this).serialize(), null, 'script' );
    return false;
  });
}

// Set a link to get via ajax
// usage:
//   ajaxifyLinks('#tags a')
function ajaxifyLinks(selector) {
  $(selector).live('click', function() {
    $.get($(this).attr('href'), $(this).serialize(), null, 'script' );
    return false;
  });
}