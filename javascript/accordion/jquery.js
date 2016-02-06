$(document).on('ready', function(){
  $(".accordion-header").on("click", function(event){
    event.preventDefault();
    if ($(this).find(".accordion-body").is(".active")) {
      $(this).find(".active").slideToggle().removeClass("active");
    } else {
      $(document).find(".active").slideToggle().removeClass("active");
      $(this).find(".accordion-body").addClass("active").slideToggle();
    }
  });

})