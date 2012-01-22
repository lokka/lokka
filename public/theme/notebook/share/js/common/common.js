
$(function(){
	$('.bubble').jrumble({
		rangeX:2,
		rangeY:2,
		rangeRot:3,
		rumbleSpeed:100
	});
	$('#items-inner').infinitescroll({
		navSelector  	: ".pager a:first",
		nextSelector 	: ".pager a:first",
		itemSelector 	: "#items-inner .item",
		loading: {
			finished: undefined,
			finishedMsg: "finished",
			img: "http://lokka-theme-notebook.heroku.com/theme/notebook/share/images/ajax-loader.gif",
			msg: null,
			msgText: "loading...",
			selector: null,
			speed: 'fast',
			start: undefined
		}
    }, function(newElements){
    	//window.console && console.log('context: ',this);
    	//window.console && console.log('returned: ', newElements);
    });
});


/* iPhone振り分け
---------------------------------------------------------------------------------------------------- */
var isiPad = navigator.userAgent.match(/iPad/i) != null;
var isiPhone = navigator.userAgent.match(/iPhone/i) != null;

if (isiPad || isiPhone) {
} else {
}



/* 外部リンクを_blankに変更
---------------------------------------------------------------------------------------------------- */
$(function() {
	$("a[href^='http://']").attr("target","_blank");
});



/* opwin
---------------------------------------------------------------------------------------------------- */
function opwin(url, width, height, trg){
	if (!!window && url) {
		if (!trg) trg = "_blank";
		options = "toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,favorites=no";
		var whop = "width="+width+",height="+height+","+options;
		win = window.open(url, trg, whop);
		win.focus();
	}
}

function opwin_c(url, trg, w, h, scroll) {
	var win_width = (screen.width - w) / 2;
	var win_height = (screen.height - h) / 2;
	win_detail = 'height='+h+',width='+w+',top='+win_height+',left='+win_width+',scrollbars='+scroll;
	win = window.open(url, trg, win_detail)
	if (parseInt(navigator.appVersion) >= 4) { win.window.focus(); }
}

//<a onClick="return refreshLink(this)" href="http://www.google.com" target="_blank">
function refreshLink(url) {
	var url = el.href;
	w = window.open();
	w.document.write('<meta http-equiv="refresh" content="0;url='+url+'">');
	w.document.close();
	return false;
}

/* rollover - fade
---------------------------------------------------------------------------------------------------- */
$(function(){
	$('.fade').hover(
		function() { $(this).fadeTo(100, 0.5); $(this).fadeTo(300, 1.0); },
		function() { $(this).fadeTo(100, 0.5); $(this).fadeTo(300, 1.0); }
	);
});

/* rollover - swapfade
----------------------------------------------------------------------------------------------------
$(function() {
  var image_cache = new Object();
  $('.swapfade').each(function(i) {
    var imgsrc = this.src;
    var dot = this.src.lastIndexOf('.');
    var imgsrc_on = this.src.substr(0, dot) + '_on' + this.src.substr(dot, 4);
    image_cache[this.src] = new Image();
    image_cache[this.src].src = imgsrc_on;
    $(this).hover(
      function() { $(this).fadeTo(320, 0.5); $(this).fadeTo(240, 1.0); this.src = imgsrc_on; },
      function() { $(this).fadeTo(240, 0.5); $(this).fadeTo(240, 1.0); this.src = imgsrc; });
  });
});
*/

/* rollover - swapfade
---------------------------------------------------------------------------------------------------- */
$(function() {
  var image_cache = new Object();
  $('.swapfade').each(function(i) {
    var imgsrc = this.src;
    var dot = this.src.lastIndexOf('.');
    var imgsrc_on = this.src.substr(0, dot) + '_on' + this.src.substr(dot, 4);
    image_cache[this.src] = new Image();
    image_cache[this.src].src = imgsrc_on;
    
    var name = "swapfade"+i;
	$(this).parent().append('<img src="'+imgsrc_on+'" class="'+name+'">');
    $(this).css("position", "absolute");
    $("."+name).css("position", "absolute");
    $("."+name).fadeTo(0, 0.0);
    $("."+name).hover(
      function() { $("."+name).fadeTo(320, 1.0);$("."+name).fadeTo(20, 0.2);$("."+name).fadeTo(100, 1.0); },
      function() { $("."+name).fadeTo(320, 0.0); });
    
  });
});


/* rollover - swap
---------------------------------------------------------------------------------------------------- */
/* プリロード無し
$(function() {
  var image_cache = new Object();
  $('.swap').each(function(i) {
    var imgsrc = this.src;
    var dot = this.src.lastIndexOf('.');
    var imgsrc_on = this.src.substr(0, dot) + '_on' + this.src.substr(dot, 4);
    image_cache[this.src] = new Image();
    image_cache[this.src].src = imgsrc_on;
    $(this).hover(
      function() { this.src = imgsrc_on; },
      function() { this.src = imgsrc; });
  });
});
*/
$(function() {
	if (!document.getElementById) return
	var aPreLoad = new Array();
	var sTempSrc;
	var aImages = document.getElementsByTagName('img');
	for (var i = 0; i < aImages.length; i++) {
		if (aImages[i].className == 'swap') {
			var src = aImages[i].getAttribute('src');
			var ftype = src.substring(src.lastIndexOf('.'), src.length);
			var hsrc = src.replace(ftype, '_on'+ftype);
			aImages[i].setAttribute('hsrc', hsrc);
			aPreLoad[i] = new Image();
			aPreLoad[i].src = hsrc;
			aImages[i].onmouseover = function() {
				sTempSrc = this.getAttribute('src');
				this.setAttribute('src', this.getAttribute('hsrc'));
			}
			aImages[i].onmouseout = function() {
				if (!sTempSrc) sTempSrc = this.getAttribute('src').replace('_on'+ftype, ftype);
				this.setAttribute('src', sTempSrc);
			}
		}
	}
	var aImagesInput = document.getElementsByTagName('input');
	for (var i = 0; i < aImagesInput.length; i++) {
		if (aImagesInput[i].className == 'swap') {
			var src = aImagesInput[i].getAttribute('src');
			var ftype = src.substring(src.lastIndexOf('.'), src.length);
			var hsrc = src.replace(ftype, '_on'+ftype);
			aImagesInput[i].setAttribute('hsrc', hsrc);
			aPreLoad[i] = new Image();
			aPreLoad[i].src = hsrc;
			aImagesInput[i].onmouseover = function() {
				sTempSrc = this.getAttribute('src');
				this.setAttribute('src', this.getAttribute('hsrc'));
			}
			aImagesInput[i].onmouseout = function() {
				if (!sTempSrc) sTempSrc = this.getAttribute('src').replace('_on'+ftype, ftype);
				this.setAttribute('src', sTempSrc);
			}
		}
	}
});


/* flash - liquid
---------------------------------------------------------------------------------------------------- */

function chageHeight(h)
{
	$('#index').height(h);
}

