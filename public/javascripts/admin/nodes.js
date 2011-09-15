function populateFormFieldAutocomplete(data_source, target_field) {
  $.get(data_source, function(data) {
    $(target_field).autocomplete({
      minLength: 0,
      source: function(request, response) {
        // delegate back to autocomplete, but extract the last term
        response($.ui.autocomplete.filter(data, request.term.split(/,\s*/).pop()));
      },
      focus: function() {
        // prevent value inserted on focus
        return false;
      },
      select: function(event, ui) {
        var terms = this.value.split(/,\s*/);
        // remove the current input
        terms.pop();
        // add the selected item
        terms.push( ui.item.value );
        // add placeholder to get the comma-and-space at the end
        terms.push("");
        this.value = terms.join(", ");
        return false;
      }
    });
  });
};

function formFieldAutocomplete(data_source, target_field) {
  if ($(target_field)) {
    populateFormFieldAutocomplete(data_source, target_field);
  };
};

function groupsAutocomplete() {
  formFieldAutocomplete('/admin/groups.json', "input.groups-completer");
};

function keywordsAutocomplete() {
  formFieldAutocomplete('/admin/keywords.json', "input.keywords-completer");
};

$(function() {
  groupsAutocomplete();
  keywordsAutocomplete();
});