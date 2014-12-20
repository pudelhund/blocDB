function submitComment(boulder_id, author_id)
{
    var comment = $('#comment_for_'+boulder_id).val();
    $.ajax({
        type: "POST",
        url: "/comments",
        data: "comment=" + escape(comment) + "&boulder_id=" + boulder_id + "&author_id=" + author_id,      
        success: function (data) {
            $('#dialog').html(data);
        },
    });
}

function deleteComment(comment_id, boulder_id)
{
	if(confirm("Bist du sicher ?"))
	{
		$.ajax({
	        type: "DELETE",
	        url: "/comments/" + comment_id,
	        data: "boulder_id=" + boulder_id,
	        success: function (data) {
	            $('#dialog').html(data);
	        },
	    });
	}
}