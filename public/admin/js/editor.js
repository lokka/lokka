$(function() {
  var wysiwyg;
  var textarea = $('textarea.editor').clone();
  var plainTextareaMode;

  var switchTextareaAndWysiwyg = (function() {
    var name = $('select[name$="[markup]"] option:selected').val();
    name = name == '' ? 'html' : name
    var html;
    if (name == 'html') {
      // enable wysiwyg
      if (plainTextareaMode) {
        textarea = $('textarea.editor').clone();
        translateToWysiwyg($('textarea.editor'));
        plainTextareaMode = false;
      }
    } else {
      // enable textarea
      if (!plainTextareaMode) {
        html = wysiwyg[0].contentDocument.body.innerHTML;
        textarea[0].innerHTML = html;
        $('#editor').empty();
        $('#editor').prepend(textarea);
        plainTextareaMode = true;
      }
    }
  });

  var translateToWysiwyg = (function(jQueryObj) {
    jQueryObj.wysiwyg(); // TODO: add options
    wysiwyg = $('.wysiwyg iframe');
  });

  $('select[name$="[markup]"]').change(switchTextareaAndWysiwyg);

  plainTextareaMode = true;

  switchTextareaAndWysiwyg();
});
