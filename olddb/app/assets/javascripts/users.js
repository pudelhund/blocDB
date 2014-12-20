$(document).ready(function(){
	$('#users').dataTable({
		bPaginate: false,
		bJQueryUI: true,
		bSortClasses: false,
        aaSorting: [[1, "asc"]],
		"aoColumnDefs": [
			{ "bSortable": false, "aTargets": [ -1, -2, -3, -4 ] },
			{ "bVisible": false, "aTargets": [ "hide" ] },
    		{ "iDataSort": 5, "aTargets": [ 6 ] }
    	]
	});

	$('#user_birthday').datepicker({ 
		dateFormat: "yy-mm-dd",
		changeYear: true,
		yearRange: "1945:2100"
	});

	$('#compares').dataTable({
		bPaginate: false,
		bJQueryUI: true,
		bSortClasses: false,
        aaSorting: [[3, "asc"]],
		"aoColumnDefs": [
			{ "bSortable": false, "aTargets": [ -1 ] },
            { "bSearchable": false, "aTargets": [ -1 ] },
			{ "bVisible": false, "aTargets": [ "hide" ] },
            { "iDataSort": 12, "aTargets": [ 13 ] },
			{ "iDataSort": 14, "aTargets": [ 15 ] },
            { "iDataSort": 5, "aTargets": [ 6 ] },
			{ "sType": "string", "aTargets": [ 0, 1, 2, 3, 4 ] },
            { "sType": "numeric", "aTargets": [ 12 ] }
		]

	});


	$('#compareto-form select').change(function(){
		var action = $('#compareto-form').attr('action');
		action = action + $(this).val();
		$('#compareto-form').attr('action', action);
		$('#compareto-form').submit();
	});

	$('#compares a.show').click(function() {
        openModalDialog(this.href, {height: 500, width: 500, title: this.title});
        return false;
    });
	
	$('a.doubt-link').click(function() {
        openModalDialog(this.href, {height: 300, width: 500, title: "Leistung anzweifeln"});
        return false;
    });
});

function submitDoubt(boulder_id, user_id, author_id)
{
    var doubt = $('#doubt_for_'+boulder_id).val();
    $.ajax({
        type: "POST",
        url: "/boulder_doubts",
        data: "description=" + escape(doubt) + "&boulder_id=" + boulder_id + "&user_id=" + user_id + "&author_id=" + author_id + "&status=1",      
        success: function (data) {
			$('#boulder_points_'+boulder_id).html(data);
			$('#dialog').remove();
			
			if(window.location.pathname.indexOf("/users") == 0)
			{
				// if we are on compare page, reload
				//window.location.reload();
				
				$('#doubt_link_'+boulder_id).remove();
				var image = $('#image_'+boulder_id+"_"+user_id);
				var src = image.attr("src");
				src = src.split(".")[0] + "-doubt.png";
				image.attr("src", src);
			}
        },
    });
}