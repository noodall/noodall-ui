tinyMCEPopup.requireLangPack();

var AddvideoDialog = {
	init : function() {
		var f = document.forms[0];

		// Get the selected contents as text and place it in the input
		f.videourl.value = tinyMCEPopup.editor.selection.getContent({format : 'text'});
	},

	insert : function() {
		// Insert the contents from the input into the document
		
		var url = document.forms[0].videourl.value;
		
		tinyMCEPopup.editor.execCommand('mceInsertContent', false, "<a href='" + url + "' title=''><img src='http://img.youtube.com/vi/" +  url + "/1.jpg' /></a>");
		tinyMCEPopup.close();
	}
};

tinyMCEPopup.onInit.add(AddvideoDialog.init, AddvideoDialog);