
(function() {
	tinymce.create('tinymce.plugins.TinyMceHelp', {
		init : function(ed, url) {
			// Register the command so that it can be invoked by using tinyMCE.activeEditor.execCommand('mceExample');
			ed.addCommand('mceHelp', function() {
				ed.windowManager.open({
					file : url + '/tinymcehelp.htm',
					width : 860 + parseInt(ed.getLang('tinymcehelp.delta_width', 0)),
					height :700 + parseInt(ed.getLang('tinymcehelp.delta_height', 0)),
					inline : 1
				}, {
					plugin_url : url
				});
			});

			// Register addvideo button
			ed.addButton('tinymcehelp', {
				title : 'Tinymce Help',
				cmd : 'mceHelp',
				image : url + '/img/help.gif'
			});

			// Add a node change handler, selects the button in the UI when a image is selected
			ed.onNodeChange.add(function(ed, cm, n) {
				cm.setActive('help', n.nodeName == 'IMG');
			});
		},

		/**
		 * Creates control instances based in the incomming name. This method is normally not
		 * needed since the addButton method of the tinymce.Editor class is a more easy way of adding buttons
		 * but you sometimes need to create more complex controls like listboxes, split buttons etc then this
		 * method can be used to create those.
		 *
		 * @param {String} n Name of the control to create.
		 * @param {tinymce.ControlManager} cm Control manager to use inorder to create new control.
		 * @return {tinymce.ui.Control} New control instance or null if no control was created.
		 */
		createControl : function(n, cm) {
			return null;
		},

		/**
		 * Returns information about the plugin as a name/value array.
		 * The current keys are longname, author, authorurl, infourl and version.
		 *
		 * @return {Object} Name/value array containing information about the plugin.
		 */
		getInfo : function() {
			return {
				longname : 'Help plugin',
				author : 'Some author',
				authorurl : 'http://tinymce.moxiecode.com',
				infourl : '',
				version : "1.0"
			};
		}
	});

	// Register plugin
	tinymce.PluginManager.add('tinymcehelp', tinymce.plugins.TinyMceHelp);
})();