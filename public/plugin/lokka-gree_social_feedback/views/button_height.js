$(function() {
 var button = $('#gree_social_feedback_button');    
 button.change(function() {
   changeButtonHeight($(this).val(), -1);
 });
})

function changeButtonHeight(buttonType, val) {
  if(buttonType == "") buttonType = "0";
  var button_height = $('#gree_social_feedback_height');    
  var height_0 = new Array('16', '20', '23');
  var height_1 = new Array('16', '22', '32');
  var height = new Array(height_0, height_0, height_0, height_0, height_1);
  for(var i = 0; i < 3; i++) {
    var h = height[parseInt(buttonType)][i];
    var obj = $('#gree_social_feedback_height_' + i);
    obj.attr('value', h);
    obj.text(h);
    if(val > -1 && val == h) {
      obj.attr('selected', 'selected');
    }
  }
}
