// Turn off fancy box keypresses
$.fn.fancybox.defaults.enableEscapeButton = false;

// We should remove once JQuery UI is updated
$.extend($.ui.autocomplete, {
  escapeRegex: function(value) {
    return value.replace(/([\^\$\(\)\[\]\{\}\*\.\+\?\|\\])/gi, "\\$1");
  },
  filter: function(array, term) {
    var matcher = new RegExp($.ui.autocomplete.escapeRegex(term), "i");
    return $.grep(array, function(value) {
      return matcher.test(value.label || value.value || value);
    });
  }
});

function setup_tooltips() {
  // tooltip for question mark icons
  var version = parseInt($.browser.version.substr(0, 1));
  var tooltip_elements = 'span.tooltip';
  if ($.browser.msie && version == 6) {
    return false;
  }
  else {
    $(tooltip_elements).unbind();
    $(tooltip_elements).hover(
    function() {
      this.tip = this.title;
      $(this).append('<div class="tooltip-show">' + this.tip + '</div>');
      this.title = "";
      this.width = $(this).width();
      $(this).find('.tooltip-show').css({
        left: this.width - 80
      });
      $('.tooltip-show').fadeIn(400);
    },
    function() {
      $('.tooltip-show').fadeOut(400);
      $(this).children().remove();
      this.title = this.tip;
    });
  }
}

function set_up_tags() {
  $('span.tags a').click(function() {
    target = $($(this).attr('href'));
    if (target.val()) {
      target.val(target.val() + ', ' + $(this).text());
    } else {
      target.val($(this).text());
    }
    return false;
  });
}

$(document).ready(function() {

  //video previews
  domain = window.location.href.replace(/http:\/\/([^\/]+)\/.*/i,'$1');
  var videoUrl = 'video=http://'+ domain + escape($('a.lightboxVideo').attr('href')) + '&standalone=true';

  $('a.lightboxVideo').fancybox({
    'padding': 10,
    'autoScale': true,
    'transitionIn': 'elastic',
    'transitionOut': 'elastic',
    'title': false,
    'titleShow': false,
    'width': 700,
    'height': 400,
    'type': 'swf',

    'swf': {
      'allowFullScreen': true,
      'flashvars': videoUrl,
      wmode: 'transparent'
    },

    'href': '/flash/video.swf',
    'centerOnScroll': true
  });

  setup_tooltips();

  // Template Choices
  $('.template label img').hide();
  $('.template label img').css({
    position: 'absolute'
  });
  $('.template input:radio:checked').parent().children('img').show();
  $('.template input').click(function() {
    $('.template label img').hide();
    $(this).parent().children('img').fadeIn('fast');
    var imgHeight = $(this).parent().children('img').height() + 100 ;
    $('#main-form').css({'min-height' : imgHeight + 'px'});
  });

  //Field Types on form creator
  if ($('#field-type').length > 0) {

    var current_help = '';
    $('.field-help').hide();
    $('#' + $('#field-type option:selected').val()).show();

    current_help = $('#' + $('#field-type option:selected').val());

    $('#field-type').change(function() {
      $(current_help).hide('fast');
      $('#' + $('#field-type option:selected').val()).show('fast');
      current_help = $('#' + $('#field-type option:selected').val());
    });
  }

  // Advanced Publishing Options
  //hide the options if you click outside of the grey box (needs improving to include the tinymce window)
  $('#main-form').click(function(e) {
    //Hide the menus if visible
    if ($(".show-advanced a.advanced").hasClass('open')) {
      e.stopPropagation();
      $("#advanced").stop(true, true).slideUp("fast");
      $(".show-advanced a.advanced").removeClass("open");
    }
  });

  $("#advanced").hide();
  $("legend.advanced").hide();

  $(".show-advanced").append("<a class='advanced' href='#advanced'>Advanced</a>");

  $(".show-advanced a.advanced").click(
  function() {
    if ($(".show-advanced a.advanced").hasClass('open')) {
      $("#advanced").stop(true, true).slideUp("fast");
      $(".show-advanced a.advanced").removeClass("open");
    } else {
      $("#advanced").stop(true, true).slideDown("fast");
      $(".show-advanced a.advanced").addClass("open");
      $(".show-advanced a.advanced.open").fadeIn("fast");
    }
  });



  set_up_tags();


  $('body#assets.index .file').click(function() {
    document.location = $(this).find("a.show").attr('href');
  });

  // slot form lightbox, used in nodes cms forms
  $('a.slot_link').fancybox({
    'autoScale': false,
    // 'transitionIn'  : 'none',
    // 'transitionOut'  : 'none',
    'title': false,
    'centerOnScroll': true,
    'hideOnOverlayClick': true,
    'hideOnContentClick': false,
    'onComplete': Component.fancy_open_slot
  });

  $('a.slot_link').click(function(e){
    e.stopImmediatePropagation();
    return false;
  });

  // Preview
  preview_link = $('<a class="preview" href="#preview-pane" title="Content Preview">Preview</a>');

  $("body#nodes.show #publish").after(preview_link);

  // Using selectors as latest version of webkit does not like binding to objects
  $('a.preview').fancybox({
    'autoDimensions': false,
    'width': '95%',
    'height': '95%'
  });
  $('a.preview').click(get_preview_html);
  // Original code
  // preview_link.fancybox({
  //      'autoDimensions' : false,
  //      'width'          : '95%',
  //      'height'         : '95%'
  // });
  // preview_link.click(get_preview_html);
  // Change the component
  $('select.component-selector').bind('change', open_component_form);

  // Set up table
  initComponentTable();

  // Set up multi files
  // Hide the last multi file li which is empty and used as a template
  $('li.multi-file:last-child').hide();
  // Hide the file details elements
  $('li.multi-file .file-form').hide();
  // Make them sortable
  $('.multi-file-files ol').sortable({
    axis: 'y',
    handle: 'img'
  });

  $('#versions-button').fancybox({'autoDimensions':false});

  // Add emptys div for browsers/preview
  $('body').append('<div style="display:none;"><div id="asset-browser"></div><div id="tree-browser"></div><div id="preview-pane"><iframe name="preview-frame" src="about:blank"/></div></div>');

  $('#parent-title a.edit-item').fancybox();
});

function get_preview_html(e) {
  preview_params = $('div#content form').serializeArray();
  var preview_form = $("<form>").attr("method", "post").attr("sytle", "display:none;").attr("target", "preview-frame").attr("action", $('div#content form').attr('action') + "/preview");
  $.each(preview_params, function(i, element) {
    if (element.name != '_method') {
      $("<input type='hidden'>").attr("name", element.name).attr("value", element.value).appendTo(preview_form);
    }
  });
  preview_form.appendTo("body");
  preview_form.submit();
  preview_form.remove();
};

function initComponentTable() {
  // Mark slots that have content as filled
  $('table.component-table td a').each(function(i, link) {
    target = '#' + this.href.split('#').pop();
    if ($(target + ' .component_form_detail').text().replace(/[\s\t]/g, '') !== "") {
      $(this).addClass('filled');
    }
  });
}

var NoodallNode = {
  id: function() {
    return $('form#node-form').attr('action').split('/').pop();
  }
};

var Component = {
  last_slot_index: 0,
  last_slot_type: null,
  last_component_type: null,
  set_slot: function(select_tag) {
    target = $(select_tag);
    Component.last_component_type = target.val();
    Component.last_slot_type = target.attr('id').replace(/([^_]+)_slot_\d+_type/i, "$1");
    Component.last_slot_index = target.attr('id').replace(/[^_]+_slot_(\d+)_type/i, "$1");
  },
  fancy_open_slot: function(args) {
    Component.open_slot(args[0]);
  },
  open_slot: function(slot_link) {
    Component.slot_form_id = '#' + $(slot_link).attr('href').split('#').pop();
    Component.slot_form = $(Component.slot_form_id);
    Component.slot_reset = Component.slot_form.clone();

    //trigger load events attached to any textareas (tinymce)
    Component.slot_reset.find('textarea.lite-editor').tinymce(lite_tiny_mce_config);
  },
  reopen_slot: function(e) {
    // reopen the last form
    $.fancybox({
      'href': Component.slot_form_id,
      'onComplete': function(){ $(Component.slot_form_id + ' textarea.lite-editor').tinymce(lite_tiny_mce_config); }
    });
  },
  reset_slot: function(e) {
    $.fancybox.close();
    Component.slot_form.replaceWith(Component.slot_reset.clone());

    // Reset
    Component.slot_form = $(Component.slot_form_id);

    // Make file selectors sortable
    Component.slot_form.find('.multi-file-files ol').sortable({
      axis: 'y',
      handle: 'img'
    });
    Component.slot_form.find('select.component-selector').bind('change', open_component_form);

    $('#' + Component.last_slot_type + '_slot_' + Component.last_slot_index + '_tag').html(Component.slot_form.find('select.component-selector').val());
    return false;
  },
  add_asset: function(asset_id) {
    file_form = Component.slot_form.find('.multi-file:last').first().clone();
    file_form.prepend(Browser.assets_to_add_html[asset_id]);
    file_form.find('.asset_id').first().val(asset_id);
    Component.slot_form.find('.multi-file-files ol li:last').before(file_form); // Before the last as the last is the hidden emtpty
    // enable all form fields
    file_form.find('input').removeAttr('disabled');
    file_form.find('textarea').removeAttr('disabled');
    file_form.show();
    // Hide the file details elements
    Component.slot_form.find('li.multi-file .file-form').hide();
  },
  add_all_assets: function() {
    $.each(Browser.assets_to_add, function(i, asset_id){
       Component.add_asset(asset_id);
    });
    Component.reopen_slot();
  }
};

var Browser = {
  assets_to_add: [],
  assets_to_add_html: [],
  allowed_types: [],
  mode: 'single', // Single or Multi
  set_opener: function(opening_tag) {
    Browser.opener = opening_tag;
    // use the HTML5 data attribute data-file-types if it exists of look for an element
    // with the class "types" for backwards compatibility with legacy projects
    var types_text = Browser.opener.attr('data-file-types') || Browser.opener.siblings('.types').text();
    if (types_text && types_text.length > 0) {
      Browser.allowed_types = types_text.toLowerCase().split(', ');
    } else {
      Browser.allowed_types = [];
    }
  },
  toggle_added_asset: function(id, e) {
    id_in_array = $.inArray(id, Browser.assets_to_add);
    if (id_in_array == -1) {
      Browser.assets_to_add.push(id);
      Browser.assets_to_add_html[id] = $('#asset-' + asset_id ).clone();
    } else {
      Browser.assets_to_add.splice(id_in_array,1);
      Browser.assets_to_add_html.splice(id_in_array,1);
    }
    if (Browser.mode == 'single') {
      Browser.do_action_and_close(e);
    }
  },
  toggle_from_link: function(e) {
    // Get the id from the href
    asset_id = $(this).siblings('a.show').attr('href').split('?')[0].split('/').pop();
    $(this).toggleClass('selected');
    Browser.toggle_added_asset(asset_id, e);
    return false;
  },
  attach_asset: function() {
    asset_id = Browser.assets_to_add[0];
    if (asset_id) {
        // Remove the current
      $(Browser.opener).closest('.file-selectable').find('.file-detail').remove();
      // Set the detail
      $(Browser.opener).closest('.file-selectable').prepend(Browser.assets_to_add_html[asset_id]);
      // Stick it in the asset_id
      $(Browser.opener).closest('.file-selectable').find('.asset_id').val(asset_id);
    }
    return false;
  },
  close: function() {
    Browser.before_close();
    $('#asset-browser').removeClass(Browser.mode);
    Browser.assets_to_add = [];
    Browser.allowed_types = [];
    Browser.mode = 'single';
    Browser.after_close();
    // Reset callbacks
    Browser.before_close = $.noop;
    Browser.after_close = $.noop;
    return false;
  },
  open: function() {
    // open asset lightbox
    action = '/';
    if (Browser.allowed_types.length > 0) {
      action += Browser.allowed_types[0];
    }
    $.get("/admin/assets" + action, {
      allowed_types: Browser.allowed_types,
      mode: Browser.mode,
      readonly:true
    },
    function() {
      // reopen the opening form if you close this form
      $.fancybox({
        href: '#asset-browser',
        onClosed: Browser.close
      });
      $('#asset-browser').addClass(Browser.mode);
    },
    'script');

    return false;
  },
  after_ajax: function() {
    if (Browser.mode == 'multi') {
      $.each(Browser.assets_to_add, function(i, asset_id){
        $('#asset-' + asset_id).siblings('a.add').addClass('selected');
      });
    }
  },
  do_action_and_close: function(e) {
    Browser.action(e);
    Browser.close();
  },
  // Callback stubs to be overridden
  before_close: $.noop,
  after_close: $.noop,
  action: $.noop
};

function open_component_form(e) {
  Component.set_slot(e.target);

  form_detail = $(e.target).closest('div.component_form').find('.component_form_detail');

  // unload tinymce on previous textareas
  form_detail.find('.lite-editor, .editor').each(function(){
    tinyMCE.get($(this).attr('id')).remove();
  });

  // Set the slot to nil to clear on save
  form_detail.html('<input name="node[' + Component.last_slot_type + '_slot_' + Component.last_slot_index + ']" type="hidden" value=""/>');

  table_cell = $("table.component-table td a[href$='" + Component.slot_form_id + "']");

  if (Component.last_component_type === '') {
    $('#' + Component.last_slot_type + '_slot_' + Component.last_slot_index + '_tag').html('');
    // Mark table cell as filled
    table_cell.removeClass('filled');
    return;
  }
  table_cell.addClass('filled');

  prefix = target.attr('id').replace(/([^_]+_slot_\d+)_type/i, "$1");

  // get module html
  $.get('/admin/components/form/' + Component.last_component_type.toLowerCase().replace(/\s/g, '_'), {
    slot: Component.last_slot_type + '_slot_' + Component.last_slot_index
  },
  function(data) {
    form_detail.html(data);
    $('#' + Component.last_slot_type + '_slot_' + Component.last_slot_index + '_tag').html(Component.last_component_type);
    Component.slot_form.find('li.multi-file').last().hide();
    Component.slot_form.find('textarea.lite-editor').tinymce(lite_tiny_mce_config);
  });
}

function clear_component_form(e) {
  slot_form = $(e.target).closest('div.component_form');
  select_tag = slot_form.find('select.component-selector');
  select_tag.val('');
  select_tag.trigger('change');
  $.fancybox.close();
    //remove filled indicator
  $("table.component-table td a[href$='#" + slot_form.attr('id') + "']").removeClass('filled');
}

function detach_asset_browser_image(event) {
  form_detail = $(event.target).closest('.component_form_detail');

  if (form_detail.find('input.asset_id').size() > 2) {
    //remove this one
  } else {

  }
}


// LIVE ELEMENTS
// Comment delete buttons
$('table.comments a.delete').live('click', function() {
  if (confirm('Are you sure you wish to delete this comment?')) {
    $.ajax({
      url: $(this).attr('href'),
      type: 'DELETE',
      contentType: 'text/javascript'
    });
  }
  return false;
});

// the button at the bottom of ever component lightbox that does the same thing as the lightbox close button
$('.form-save').live('click', $.fancybox.close);

// the button at the bottom of every component lightbox that clears component
$('.form-reset').live('click', Component.reset_slot);

// the button at the bottom of every component lightbox that clears component
$('.form-delete').live('click', clear_component_form);

// Cancel button
$('#asset-browser li.cancel a').live('click', Browser.close);

// Action button
$('#asset-browser li.action a').live('click', Browser.do_action_and_close);

// Open the file select
$('span.select-file').live('click', function(event) {
  Browser.set_opener($(this));
  Browser.action = Browser.attach_asset;
  Browser.after_close = $.fancybox.close;
  Browser.open();
});
// After close the file select in component form reopen slot form
$('.component_form span.select-file').live('click', function(event) {
  Browser.after_close = Component.reopen_slot;
});

// Open the file select for multi file component
$('.add-multi-asset').live('click', function(event) {
  Browser.mode = 'multi';
  Browser.set_opener($(this));
  Browser.action = Component.add_all_assets;
  Browser.after_close = Component.reopen_slot;
  Browser.open();
});

// Mark an asset to be added an asset into the component
$('#asset-browser a.add').live('click', Browser.toggle_from_link);

// Remove multi file
$('li.multi-file span.done').live('click', function(e) {
  $(this).closest('.multi-file').find('.file-form').hide();
});

$('li.multi-file span.edit').live('click', function(e) {
  $(this).closest('.multi-file').find('.file-form').toggle();
});

$("li.multi-file span.delete").live("click", function(e) {
  $(this).closest('li.multi-file').remove();
});

// Node mover and shaker
//$('span.node-mover, #parent-title').live('click', function(event) {
  //// open asset lightbox
  //$('#tree-browser').get($(this).attr('href'), {
    //allowed_types: $('#parent_types').val().split(','),
    //not_branch: node_id
  //},
  //function() {
    //// reopen the opening form if you close this form
    //$.fancybox({
      //href: '#tree-browser',
      //title: "Select a parent"
    //});
  //},
  //'script');

  //event.stopImmediatePropagation();
  //return false;
//});

$('ol.tree a.choose').live('click', function(e) {
  id = this.id.replace('id-', '');
  $('#node_parent').val(id);
  $('#parent-title strong').html($(this).text());
  $.fancybox.close();
  return false;
});

// Node Linker
$('span.link-node').live('click', function(event) {
  Component.link_input = $(this).siblings('input').first();
  // open asset lightbox
  $.get("/admin/nodes/tree", function() {
    // reopen the opening form if you close this form
    $.fancybox({
      href: '#tree-browser',
      title: "Link to content"
    });
    $('#tree-browser').attr('class', 'link');
  },
  'script');

  event.stopImmediatePropagation();
  return false;
});

$('#tree-browser.link a').live('click', function(e) {
  $(Component.link_input).val($(this).attr('href'));
  Component.reopen_slot();
  return false;
});

// Asset Linker
$('span.link-asset').live('click', {readonly:true}, function(event) {
  Component.link_input = $(this).siblings('input').first();
  Browser.set_opener($(this));
  Browser.action = function(e) {
    $(Component.link_input).val($(e.target).attr('href'));
  };
  Browser.after_close = Component.reopen_slot;
  Browser.open();
});

