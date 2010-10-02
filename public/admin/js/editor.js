$(function(){
  $("textarea.editor").htmlarea({
    css: '/admin/css/editor.css',
    toolbar: [
      ["html"], ["p", "bold", "italic", "underline", "|", "forecolor"],
      ["link", "unlink", "image"],
      [{
        css: "code",
        text: "Code",
        action: function(btn) {
          this.pasteHTML('<pre><code>' + this.getSelectedHTML() + '</code></pre>');
        }
      }]
    ]
  })
})
