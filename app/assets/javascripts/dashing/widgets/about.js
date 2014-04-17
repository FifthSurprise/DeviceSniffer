$(document).ready(function(){
  
  var $overlay = $('<div id="overlay"></div>');
  var $caption = $('<p>Using the MAC addresses detected by the Meraki Router here at the Flatiron School<br>we figured out the top manufacturers and displayed it using a dashboard</p>');
  
  $overlay.append($caption);
  $("body").append($overlay);


  $("#about").click(function(event){
    // event.preventDefault();
    
    $overlay.show();   
  });

  $("#overlay").click(function(event){
    $overlay.hide();
  });
});