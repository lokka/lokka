$(function() {
  $('textarea.editor').cleditor({
    width: 550,
    height: 550,
    controls: 'bold italic underline strikethrough subscript superscript font size style | color highlight removeformat bullets numbering | outdent indent | alignleft center alignright justify | rule image link unlink | pastetext source'
  })
  $('#save_as_draft_button').click(function(event){
    var published = $('#published');
    published.val(0);
  });
})
