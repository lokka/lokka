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
        console.log(wysiwyg);
        html = wysiwyg[0].doc.body.innerHTML;
        textarea[0].innerHTML = html;
        $('div.wysiwyg').remove();
        $('#editor').prepend(textarea);
        plainTextareaMode = true;
      }
    }
  });

  var translateToWysiwyg = (function(jQueryObj) {
    wysiwyg = jQueryObj.wysiwyg();
//    wysiwyg = jQueryObj.wysiwyg({
//      width: 550,
//      height: 550,
//      controls: 'bold italic underline strikethrough subscript superscript font size style | color highlight removeformat bullets numbering | outdent indent | alignleft center alignright justify | rule image link unlink | pastetext source'
//    });
  });

  $('select[name$="[markup]"]').change(switchTextareaAndWysiwyg);

  plainTextareaMode = true;

  switchTextareaAndWysiwyg();
});
