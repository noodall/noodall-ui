tinyMCEPopup.requireLangPack();

var AddvideoDialog = {
	init : function() {
		var f = document.forms[0];

		// Get the selected contents as text and place it in the input
		f.videourl.value = tinyMCEPopup.editor.selection.getContent({format : 'text'});
		f.videtitle.value = tinyMCEPopup.editor.selection.getContent({format : 'text'});
	},

  insert : function() {
    // Insert the contents from the input into the document
    
    // VIDEO URL
    var url = document.forms[0].videourl.value;
    
    // VIDEO Title
    var title = document.forms[0].videotitle.value;
    
    // REGEXP
    var re=new RegExp(/[\\?\\&]v=([^\\?\\&]+)/);
    
    // VIDEO ID
    var videoid = re.exec(url);

    // Add Link and img to the body

    tinyMCEPopup.editor.execCommand('mceInsertContent', false, "<a href='" + url + "' title='" + title + "' class='fancy-youtube'><img src='http://img.youtube.com/vi/" +  videoid[1] + "/0.jpg' alt='" + title + "' /></a>");
    tinyMCEPopup.close();
  }
};

AddvideoDialog.init();
tinyMCEPopup.onInit.add(AddvideoDialog.init, AddvideoDialog);