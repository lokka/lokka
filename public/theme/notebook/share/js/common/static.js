
/* �v���g�^�C�v�̊g��
---------------------------------------------------------------------- */

//�S���u����ǉ�
String.prototype.replaceAll = function (org, dest){  
  return this.split(org).join(dest);  
}  

//Fisher-Yates �V���b�t��
Array.prototype.shuffle = function() {
    var i = this.length;
    while(i){
        var j = Math.floor(Math.random()*i);
        var t = this[--i];
        this[i] = this[j];
        this[j] = t;
    }
    return this;
}


/* jquery�̊g��
---------------------------------------------------------------------- */

$.fn.preload = function() {
    this.each(function(){
        $('<img/>')[0].src = this;
    });
}


/* �Z�k�\�L
---------------------------------------------------------------------- */
var log = function(e){console.log(e)};


/* Static�N���X�쐬
---------------------------------------------------------------------- */

var Static = {

	//----------------------------------------------------------------------
	//	�v�����[�h
	//	Static.preload(['images/a.jpg','images/b.jpg']);
	preload : function(ar){
		$(ar).each(function(i){
			$('<img/>')[0].src = this;
		});
		
	},

	//----------------------------------------------------------------------
	//	URL�p�����[�^���󂯎��
	//	var xml = Static.getUrlVars();
	//	alert(xml["xml"]);
	getUrlVars : function(){
		var vars = [], hash; 
		var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&'); 
		for(var i = 0; i < hashes.length; i++) { 
			hash = hashes[i].split('='); 
			vars.push(hash[0]); 
			vars[hash[0]] = hash[1]; 
		} 
		return vars; 
	},

	//----------------------------------------------------------------------
	//	String��jsonp�f�[�^��XML�ɕϊ�
	//	var xmlObject = Static.string2xml(xml);
	//	alert(xmlObject);
	string2xml : function(xmlData){
		if (window.ActiveXObject) {
			//for IE
			xmlDoc=new ActiveXObject("Microsoft.XMLDOM");
			xmlDoc.async="false";
			xmlDoc.loadXML(xmlData);
			return xmlDoc;
		} else if (document.implementation && document.implementation.createDocument) {
			//for Mozila
			parser=new DOMParser();
			xmlDoc=parser.parseFromString(xmlData,"text/xml");
			return xmlDoc;
		}
	},

	//----------------------------------------------------------------------
	//�I�u�W�F�N�g�̒��g���m�F
	showObject : function(elm,type){
		var str = '�u' + typeof elm + "�v�̒��g";
		var cnt = 0;
		for(i in elm){
			if(type == 'html'){
				str += '<br />?n' + "[" + cnt + "] " + i.bold() + ' = ' + elm[i];
			} else {
				str += '?n' + "[" + cnt + "] " + i + ' = ' + elm[i];
			}
			cnt++;
			status = cnt;
		}
		return str;
	},
	
	//----------------------------------------------------------------------
	//Amazon�p�֐�
	getAwsItem : function(asin){
		var access_key = 'AKIAIFSUVHHZZ7N4W2CA';
		var secret_key = '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';
		var associate_tag = 'prjcs-22';
		var str_imestamp = Static.getISO8601Timestamp();
		var url = "ecs.amazonaws.jp";
		var para = {
			"Service":"AWSECommerceService",
			"AWSAccessKeyId":access_key,
			"AssociateTag":associate_tag,
			"Operation":"ItemLookup",
			"ResponseGroup":"Medium",
			"ItemId":asin,
			"Version":"2009-07-01",
			"ContentType":"text/xml",
			"Timestamp":str_imestamp
		};
		
		//
		var para_array = [];
		for(var pname in para){
			var tmp = encodeURIComponent(para[pname]);
			tmp = tmp.replace("(", "%28");
			tmp = tmp.replace(")", "%29");
			tmp = tmp.replace("!", "%21");
			para_array.push(pname + "=" + tmp);
		}
		para_array.sort();
		var str_para = para_array.join('&');
		var str_signature = "GET" + "?n" + url + "?n" + "/onca/xml" + "?n" + str_para;
		HMAC_SHA256_init(secret_key);
		HMAC_SHA256_write(str_signature);
		var array_hash = HMAC_SHA256_finalize();
		var str_hash = "";
		for (var i = 0; i < array_hash.length; i++) {
			str_hash += String.fromCharCode(array_hash[i]);
		}
		var signature = Base64.encode(str_hash);
		var para_signature = "&Signature=" + encodeURIComponent(signature);
		//location.href = "http://" + url + "/onca/xml?" + str_para + para_signature;
		var awsUrl = "http://" + url + "/onca/xml?" + str_para + para_signature;
		
		//alert(awsUrl);
		return awsUrl;
	},
	getISO8601Timestamp : function(){
		var d = new Date();
		var ye = d.getUTCFullYear();
		var mo = Static.zeroPlus(d.getUTCMonth() + 1);
		var da = Static.zeroPlus(d.getUTCDate());
		var ho = Static.zeroPlus(d.getUTCHours());
		var mi = Static.zeroPlus(d.getUTCMinutes());
		var se = Static.zeroPlus(d.getUTCSeconds());
		return ye + "-" + mo + "-" + da + "T" + ho + ":" + mi + ":" + se + "Z";
	},
	
	//----------------------------------------------------------------------
	//�����̓���0�𑫂�
	zeroPlus : function(value){
		return ("0" + value).slice(-2);
	},
	
	//----------------------------------------------------------------------
	//�t���p�X�y�[�W�̉����[�J���\��
	//Static.fullpath2localpath('http://www.sony.jp');
	fullpath2localpath : function(path){
		$(function(){
			$('script').each(function(i) {
				//if(i != 1) return;
					var src = this.src;
				var count = src.indexOf('/');
				if(count == 5) {
					var full = path + src.substr(count+2, src.length);
					this.src = full;
				}
			});
			$('link').each(function(i) {
				//if(i != 1) return;
				var href = this.href;
				var count = href.indexOf('/');
				if(count == 5) {
					var full = path + href.substr(count+2, href.length);
					this.href = full;
				}
			});
			$('img').each(function(i) {
				//if(i != 1) return;
				var src = this.src;
				var count = src.indexOf('/');
				if(count == 5) {
					var full = path + src.substr(count+2, src.length);
					this.src = full;
				}
			});
		});
	},
	
	//----------------------------------------------------------------------
	
//	�����_���Ȑ�����Ԃ�
//	var n = Static.randomInt(n);
//	alert(n);
	randomInt : function(n){
		return Math.floor(Math.random()*n);
	},
//	2�_�Ԃ̋����𑪒�
//	var distance = Static.getDistance(o1,o2);
//	alert(distance);
	getDistance : function(o1,o2){
		var d,dx,dy;
		dx = o1.x - o2.x;
		dy = o1.y - o2.y;
		d = Math.sqrt(dx*dx+dy*dy);
		return d;
	},
//	2�_�Ԃ̊p�x�𑪒�
//	var r = Static.getDegrees(o1,o2);
//	var r = Static.getRadians(o1,o2);
//	alert(r);
	getDegrees : function(o1,o2){
		return (Math.atan2(o2.y-o1.y, o2.x-o1.x)) * 180/Math.PI;
	},
	getRadians : function(o1,o2){
		return Math.atan2(o2.y-o1.y, o2.x-o1.x);
	},
//	���W�A���p�ɕύX
//	var r = Static.changeRadians(degrees);
//	alert(r);
	changeRadians : function(degrees){
		return degrees * Math.PI/180;
	},
//	���W�A���p����ύX
//	var r = Static.changeDegrees(radians);
//	alert(r);
	changeDegrees : function(radians){
		return radians * 180/Math.PI;
	},
	
	
	
	
	
	
	
	
	
	
	
	
	
	//----------------------------------------------------------------------
	//----------------------------------------------------------------------
	//----------------------------------------------------------------------
	//----------------------------------------------------------------------
	//----------------------------------------------------------------------
	//�G���[���p
	fin : function(){}
}











