$(document).ready( function(){

	if($("#bread_crumb a").length == 0){
		$("#bread_crumb").html("");
		$("#bread_crumb").css("margin-bottom", "0px");
	}	else {
		$("#bread_crumb a").each(function(){
			$(this).after("　>　");
		});
	}
	
	//$("#comment_form h4").html("コメントを投稿");
	
	// $("#comment_form br").hide();
});



