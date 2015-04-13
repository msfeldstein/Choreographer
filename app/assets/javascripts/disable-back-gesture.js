$(document).on("mousewheel",function(event,delta){
  // prevent horizontal scrolling

  if (event.originalEvent.wheelDeltaX !== 0) {
    event.preventDefault();
  }
});
