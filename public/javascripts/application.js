// APPLICATION.JS
// In jQuery if you dont mind.

$(document).ready(function () {

  // Gallery
   if($("ul.gallery li").length > 3) {
      $("#gallery").prepend("<a class='carousel-back'>Backward</a>");
      $("#gallery").append("<a class='carousel-forward'>Forward</a>");

      $(".image-gallery").jCarouselLite({
         visible: 3,
         btnNext: ".carousel-forward",
         btnPrev: ".carousel-back"
      });
    };

  // Use fancy box on all images that link to an image
  $("a[href$=jpg], a[href$=png], a[href$=gif]").fancybox({
      'zoomOpacity'     : true,
      'overlayShow'     : true,
      'zoomSpeedIn'     : 500,
      'zoomSpeedOut'      : 500,
      'overlayOpacity'    : 0.8,
      'overlayColor'      : '#000'
  });

  // External links open in a new tab/window
  $("a[href^=http]").attr('target', '_blank');


}); // close document.ready
