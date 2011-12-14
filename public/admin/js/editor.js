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
    jQueryObj.wysiwyg({
      controls: {
        h1:          { visible: false },
        html:        { visible: true },
        indent:      { visible: false },
        outdent:     { visible: false },
        paragraph:   { visible: true },
        redo:        { visible: false },
        subscript:   { visible: false },
        superscript: { visible: false },
        underline:   { visible: false },
        undo:        { visible: false }
      },
      autoGrow: true,
      css: '/admin/css/editor.css'
    });
    $('.toolbar ~ div[style*="clear: both;"]').css({ clear: 'none' }); // style patch
    wysiwyg = $('.wysiwyg iframe');
  });

  $('select[name$="[markup]"]').change(switchTextareaAndWysiwyg);

  plainTextareaMode = true;

  switchTextareaAndWysiwyg();
});
