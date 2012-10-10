function setUpAssets() {
  $('#asset-browser ul.choices a, #asset-browser #tags a, #asset-browser .tags a, #asset-browser a.show, #asset-browser .pagination a').live('click', function() {
    $.get(
      $(this).attr('href'),
      { allowed_types: Browser.allowed_types, mode: Browser.mode },
      Browser.after_ajax,
      'script' );
    return false;
  });
}
setUpAssets();

function setUpPlupload() {

  $("#uploader").pluploadQueue({

    // General settings
    runtimes : 'html5,flash,gears,silverlight,html4',
    url : '/admin/assets/plupload',
    // max_file_size : '10mb',
    // chunk_size : '1mb',
    unique_names : false,

    // Use multipart
    // multipart: true,
    // multipart_params: { 'var1': 'val1', 'var2': 'val2' },

    // Resize images on clientside if we can
    // resize : {width : 320, height : 240, quality : 90},

    // Specify what files to browse for
    filters : [
      {title : "Image files", extensions : "jpg,jpeg,gif,png,tiff,bmp"},
      {title : "Zip files", extensions : "zip"},
      {title : "Flash files", extensions : "swf"},
      {title : "Document files", extensions : "doc,pdf,xls,txt,docx,ppt"},
      {title : "Video files", extensions : "flv,f4v"}
    ],
    // Flash settings
    flash_swf_url : '/assets/plupload/plupload.flash.swf',

    // Silverlight settings
    silverlight_xap_url : '/assets/plupload/plupload.silverlight.xap'

  });
  var uploader = $('#uploader').pluploadQueue();


  uploader.bind('FileUploaded', function(up, file, res) {
    if(this.total.queued === 0) {
      message = $('<div id="flash"><div class="flash notice">Assets were successfully uploaded. <strong>Please enter full information for each asset</strong></div></div>');
      message.bind('click', function() {
        window.location.href = "/admin/assets/pending";
      });
      message.css( 'cursor', 'pointer' );
      if ($('form#uploader').closest('#asset-browser').val() == undefined){
        $("#content").before(message);
        setTimeout('window.location.href = "/admin/assets/pending";', 5000);
      }
    }
  });

  var error_translations = [];
    error_translations[700] = 'File type is not allowed.';
    error_translations[600] = 'File is too large, '+ plupload.formatSize(uploader.settings.max_file_size) +' maximum.';

  uploader.bind('Error', function(up, err){
    uploader_dom = $('#uploader');

    if(uploader_dom.find('.plupload_droptext').length >0)
      uploader_dom.find('.plupload_droptext').remove();

    // get a nicer error message
    // or fail to pluploads errors
    error_message = err.message;
    err_code = Math.abs(err.code);
    if(error_translations[err_code])
      error_message = error_translations[err_code];

    error_item = $('<li></li>');
    error_item.addClass('plupload_error');
    error_item.text(error_message + (err.file ? " (" + err.file.name + ")" : ""));

    $('#uploader_filelist').append(error_item);

    error_item.delay(8000).fadeOut(2000, function(){ $(this).remove(); if($('#uploader_filelist li').length === 0) $('#uploader_filelist').append('<li class="plupload_droptext">Drag files here.</li>'); });

    up.refresh(); // Reposition Flash/Silverlight
  });
}
