$(document).ready(function() {

  // Wrap it in a div for centering
  $(".document img").wrap("<div class='image-wrap'></div>");

  // Wrap XML and ObjC in wider code blocks
  $(".highlight-xml").wrap("<div class='wide-code-block'></div>");
  $(".highlight-obj-c").wrap("<div class='wide-code-block'></div>");

  // Search toggle
  $("#search-toggle").bind('click', function() {
    $(".search-wrapper").toggleClass('active');
  });

  $("#menu-toggle").bind('click', function(e) {
    $("#main-nav-wrap").toggleClass('active');
    $(".search-wrapper").toggleClass('active');
  });

  $("#toc-toggle").bind('click', function(e) {
    $("body, .sidebar-first").toggleClass('push-right');
  });

  $(".sidebar-first .local-toc a").bind('click', function(e) {
    $("body, #side-nav").toggleClass('push-right');
  });

  // Tabbed Code Blocks
  $('div.example-code').each(function() {
    var example_sel = $('<ul />', { class: "example-selector" });
    var i = 0;
    $('div[class^="highlight-"]', this).each(function() {
      var sel_item = $('<li />', {
          class: $(this).attr('class'),
          text: $(this).attr('class').substring(10)
      });
      if (i++) {
        $(this).hide();
      } else {
        sel_item.addClass('selected');
      }
      example_sel.append(sel_item);
      $(this).addClass('example');
    });
    $(this).prepend(example_sel);
    example_sel = null;
    i = null;
  });

  $('div.example-code ul.example-selector li').click(function(evt) {
    evt.preventDefault();
    $('ul.example-selector li').removeClass('selected');
    var sel_class = $(this).attr('class');
    $('div.example').hide();
    $('div.' + sel_class).show();
    $('ul.example-selector li.' + sel_class).addClass('selected');
    sel_class = null;
  });

  var width = Math.max( $(window).width(), window.innerWidth);

  if (width < 990) {
    $('.header').toggleClass('fixed');
    $('#mobile-toc').waypoint('sticky', {
      direction: 'down right',
      stuckClass: 'stuck',
      wrapper: '<div class="mobile-toc-wrapper" />'
    });
  }

  // ======================================
  // Helper functions
  // ======================================
  // Get section or article by href
  function getRelatedContent(el){
    return $($(el).attr('href'));
  }
  // Get link by section or article id
  function getRelatedNavigation(el){
    var linkId =  $(el).attr("id");
    return $('nav.toc a[href=#'+linkId+']');
  }

  // ======================================
  // Waypoints
  // ======================================
  // Default cwaypoint settings

  $.fn.waypoint.defaults = {
    context: window,
    continuous: true,
    enabled: true,
    horizontal: false,
    offset: 20,
    triggerOnce: false
  };

  $('.section')
     .waypoint(function(direction) {
     // Highlight element when related content
     // is 10% percent from the bottom...
     // remove if below
       getRelatedNavigation(this).toggleClass('active', direction === 'down');
       getRelatedNavigation(this).next('ul').toggleClass('active', direction === 'down');
     })
     .waypoint(function(direction) {
     // Highlight element when bottom of related content
     // is 60px from the top - remove if less
       getRelatedNavigation(this).toggleClass('active', direction === 'up');
       getRelatedNavigation(this).next('ul').toggleClass('active', direction === 'up');
     }, {
       offset: function() {  return -$(this).height() + 60; }
     });

});
