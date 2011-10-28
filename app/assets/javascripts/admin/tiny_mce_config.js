lite_tiny_mce_config = {
    script_url : '/assets/tiny_mce/tiny_mce.js',

    content_css : "/assets/admin/tinymce.css",

    theme : "advanced",
    mode : "specific_textareas",
    editor_selector : "lite-editor",
    strict_loading_mode : 1,
    convert_urls : false,
    plugins : "safari,inlinepopups,xhtmlxtras,paste,media,advimage,table,addvideo",
    //"safari,pagebreak,style,layer,table,save,advhr,advimage,advlink,emotions,iespell,inlinepopups,insertdatetime,preview,media,searchreplace,print,contextmenu,paste,directionality,fullscreen,noneditable,visualchars,nonbreaking",
    // Theme options
    theme_advanced_blockformats : "h2,h3,h4,p",
    theme_advanced_buttons1 : "bold,italic,underline,|,bullist,numlist,|,link,unlink,|,table,delete_table,tablecontrols,col_before,col_after,row_before,row_after,delete_col,delete_row",
    theme_advanced_buttons2 : "",
    theme_advanced_buttons3 : "",
    theme_advanced_buttons4 : "",
    theme_advanced_path : false,
    theme_advanced_toolbar_location : "top",
    theme_advanced_toolbar_align : "left",
    theme_advanced_statusbar_location : "bottom",
    theme_advanced_resizing : true,
    theme_advanced_styles : "Footnote=footnote",

    paste_auto_cleanup_on_paste : true,
    paste_strip_class_attributes : "all",
    extended_valid_elements : "iframe[src|width|height|name|align]",
    paste_remove_spans : true,
    paste_remove_styles : true
};

tiny_mce_config = {};

// add in some bits for the advanced editor
$.extend(tiny_mce_config, lite_tiny_mce_config, {
    editor_selector : "editor",
    theme_advanced_buttons1 : "bold,italic,underline,|,formatselect,removeformat ,|,bullist,numlist,|,link,unlink,anchor,|,outdent,indent,blockquote,|,justifyleft,justifycenter,justifyright,justifyfull",
    theme_advanced_buttons2 : "table,delete_table,tablecontrols,col_before,col_after,row_before,row_after,delete_col,delete_row,|,code,attribs,image,media, assetbrowser,nodebrowser,addvideo",

    setup : function(ed) {
      // Add a custom button
      ed.addButton('assetbrowser', {
        title : 'Insert Asset',
        image : '/assets/admin/image_small.png',
        href: '#asset-browser',
        onclick : function() {
          tinyMCE.activeEditor.focus();
          tinyMCE.activeEditor.windowManager.bookmark = tinyMCE.activeEditor.selection.getBookmark();
          Browser.action = function(e) {
            e.stopImmediatePropagation();
            asset_id = Browser.assets_to_add[0]

            if (asset_id) {
              add_url = $('#asset-' + asset_id).siblings('a.show').attr('href').split('?')[0] + '/add';
              $.get(add_url, { node_id: NoodallNode.id() }, function(data) {
                $('#asset-browser').html(data);

                choices = $('#asset-browser .choice');
                if (choices.length > 0) {
                  $.each(choices, function(i, choice){
                    $(choice).click(function(e){
                      tinyMCE.activeEditor.selection.moveToBookmark(tinyMCE.activeEditor.windowManager.bookmark);
                      tinyMCE.activeEditor.selection.setContent($(this).html());
                      $.fancybox.close();
                      return false;
                    });
                  });
                } else {
                  tinyMCE.activeEditor.selection.moveToBookmark(tinyMCE.activeEditor.windowManager.bookmark);
                  tinyMCE.activeEditor.selection.setContent(data);
                  $.fancybox.close();
                  return false;
                }
              }, 'html');
            }
            return false;
          };
          Browser.open();
        }
      });

      ed.addButton('nodebrowser', {
        title : 'Insert an internal link',
        image : '/assets/admin/top-level_small.png',
        href: '#asset-browser',
        onclick : function() {
          tinyMCE.activeEditor.focus();
          tinyMCE.activeEditor.windowManager.bookmark = tinyMCE.activeEditor.selection.getBookmark();
          // open asset lightbox
          $.get("/admin/nodes/tree", function() {
            // reopen the opening form if you close this form
            $.fancybox({
              href: '#tree-browser',
              title: "Link to content"
            });
            $('#tree-browser').attr('class', 'tinymce');
          },
          'script');
        }
      });




      ed.onPostProcess.add(function(ed, o) {
        if(o.save){
          // remove mce empty spans
          o.content = o.content.replace(/<span id=._mce_start. .*?>﻿<\/span>/ig, '');
        }
      });

      // wow what a hack: insert a containing span for the page name if nothing is selected,
      // then insert the link, then remove containing span after all is good
      $('#tree-browser.tinymce li a').live('click', function(event) {
        add_url = $(this).attr('href').split('?')[0];
        tinyMCE.activeEditor.selection.moveToBookmark(tinyMCE.activeEditor.windowManager.bookmark);

        if(tinyMCE.activeEditor.selection.getContent().length === 0){
          tinyMCE.execInstanceCommand(tinyMCE.activeEditor.id, 'mceInsertRawHTML', false, '<span class="tmp_tag">' + $(this).text() + '</span>');
          spans = tinyMCE.activeEditor.dom.select('span');

          $.each(spans, function(i, span){
            if($(span).hasClass('tmp_tag')) {
              tinyMCE.activeEditor.selection.select(span);
            }
          });
        }

        tinyMCE.execInstanceCommand(tinyMCE.activeEditor.id, 'mceInsertLink', false, add_url, true);
        $.fancybox.close();

        tinyMCE.activeEditor.setContent(tinyMCE.activeEditor.getContent().replace(/<span class="tmp_tag">(.*?)<\/span>/i, "$1"));

        event.stopImmediatePropagation();
        return false;
      });

    }
});



$(function() {
  $('textarea.editor').tinymce(tiny_mce_config);
});
