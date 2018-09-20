jQuery(document).ready(function(){
  jQuery('#texto').keypress(function(evt){
    if (evt.keyCode == 13){
      // Enter, simulate clicking send
      jQuery('#enviar').click();
    }
  });
});