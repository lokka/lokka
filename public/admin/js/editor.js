$(function() {
  var cleditor;
  var textarea = $('textarea.editor').clone();
  var plainTextareaMode;

  var switchTextareaAndCleditor = (function() {
    var name = $('select[name$="[markup]"] option:selected').val();
    name = name == '' ? 'html' : name
    var html;
    if (name == 'html') {
      // enable cleditor
      if (plainTextareaMode) {
        textarea = $('textarea.editor').clone();
        translateToCleditor($('textarea.editor'));
        plainTextareaMode = false;
      }
    } else {
      // enable textarea
      if (!plainTextareaMode) {
        html = cleditor[0].doc.body.innerHTML;
        textarea[0].innerHTML = html;
        $('.cleditorMain').remove();
        $('#editor').prepend(textarea);
        plainTextareaMode = true;
      }
    }
  });

  var translateToCleditor = (function(jQueryObj) {
    cleditor = jQueryObj.cleditor({
      width: 550,
      height: 550,
      controls: 'bold italic underline strikethrough subscript superscript font size style | color highlight removeformat bullets numbering | outdent indent | alignleft center alignright justify | rule image link unlink | pastetext source'
    });
  });

  $('select[name$="[markup]"]').change(switchTextareaAndCleditor);

  plainTextareaMode = true;

  switchTextareaAndCleditor();
});
