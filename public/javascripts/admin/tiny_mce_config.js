lite_tiny_mce_config = {
    script_url : '/javascripts/tiny_mce/tiny_mce.js',

    content_css : "/stylesheets/admin/tinymce.css",

    theme : "advanced",
    mode : "specific_textareas",
    editor_selector : "lite-editor",
    strict_loading_mode : 1,
    convert_urls : false,
    plugins : "safari,inlinepopups,xhtmlxtras,paste,media,advimage,table,media",
    //"safari,pagebreak,style,layer,table,save,advhr,advimage,advlink,emotions,iespell,inlinepopups,insertdatetime,preview,media,searchreplace,print,contextmenu,paste,directionality,fullscreen,noneditable,visualchars,nonbreaking",
    // Theme options
    theme_advanced_blockformats : "h2,h3,h4,p",
    theme_advanced_buttons1 : "bold,italic,underline,|,tablecontrols",
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
    paste_strip_class_attributes: 'mso'
};

tiny_mce_config = {};

// add in some bits for the advanced editor
$.extend(tiny_mce_config, lite_tiny_mce_config, {
    editor_selector : "editor",
    theme_advanced_buttons1 : "bold,italic,underline,|,formatselect,removeformat ,|,bullist,numlist,|,link,unlink,anchor,|,outdent,indent,blockquote,|,justifyleft,justifycenter,justifyright,justifyfull",
    theme_advanced_buttons2 : "tablecontrols,|,code,attribs,image,media, assetbrowser,nodebrowser",
    
    setup : function(ed) {
      // Add a custom button
      ed.addButton('assetbrowser', {
        title : 'Insert Asset',
        image : '/images/admin/image_small.png',
        href: '#asset-browser',
        onclick : function() {
          $.get("/admin/assets", {readonly:true}, function() {
            $.fancybox({ 'href': '#asset-browser' });
            $('#asset-browser').attr('class','tinymce');
          }, 'script' );
        }
      });
      
      ed.addButton('nodebrowser', {
        title : 'Insert an internal link',
        image : '/images/admin/top-level_small.png',
        href: '#asset-browser',
        onclick : function() {
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
      
      $('#asset-browser.tinymce li a.add').live('click', function(event) {
        add_url = $(this).siblings('a.show').attr('href').split('?')[0] + '/add';
        $.get(add_url, { node_id: Node.id() }, function(data) {
          tinyMCE.activeEditor.focus();
          tinyMCE.activeEditor.selection.setContent(data);
          $.fancybox.close();
        }, 'html');
        
        event.stopImmediatePropagation();
        return false;
      });

      // wow what a hack: insert a containing span for the page name if nothing is selected,
      // then insert the link, then remove containing span after all is good
      $('#tree-browser.tinymce li a').live('click', function(event) {
        add_url = $(this).attr('href').split('?')[0];
        
        if(tinyMCE.activeEditor.selection.getContent().length == 0){
          tinyMCE.execInstanceCommand(tinyMCE.activeEditor.id, 'mceInsertRawHTML', false, '<span class="tmp_tag">' + $(this).text() + '</span>');
          spans = tinyMCE.activeEditor.dom.select('span');
          
          $.each(spans, function(i, span){
            if($(span).hasClass('tmp_tag'))
              tinyMCE.activeEditor.selection.select(span);
          });
        }
        
        tinyMCE.execInstanceCommand(tinyMCE.activeEditor.id, 'mceInsertLink', false, add_url, true)
        $.fancybox.close();
        
        tinyMCE.activeEditor.setContent(tinyMCE.activeEditor.getContent().replace(/<span class="tmp_tag">(.*?)<\/span>/i, "$1"));
        
        event.stopImmediatePropagation();
        return false;
      });

    }
});


    
/* this has been left on the load event, 
   though live doesn't capture the load event, i am manually triggering it as above
*/
$('textarea.lite-editor').live('load', function(){ $(this).tinymce(lite_tiny_mce_config); });
$('textarea.editor').live('load', function(){ $(this).tinymce(tiny_mce_config); });


$(function() {
  $('textarea.lite-editor').trigger('load');
  $('textarea.editor').trigger('load');
});
