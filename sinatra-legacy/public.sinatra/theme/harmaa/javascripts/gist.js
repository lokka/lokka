$(function() {
  $('.gists').each(function() {
    var $this = $(this);
    var scriptSrc = '<scr'+'ipt src="' + $this.text() + '" type="text/javascript"></scr'+'ipt>';
    var isLine = ($this.data('gistline') !== undefined)? true: false;

    $this.writeCapture().html(scriptSrc, function() {
      if(isLine === false) return false;

      $this.each(function() {
        $(this).find('.line').each(function(i, e) {
          $(this).prepend($('<div/>').attr('unselectable','on').addClass('gist-line-no').text(++i));
        });
      });
    });
  });
});