$(document).ready(function(){
	$('#boulder_doubts').dataTable({
		bPaginate: false,
    	bJQueryUI: true,
    	bSortClasses: false,
        aaSorting: [[1, "asc"]],
            "aoColumnDefs": [
                { "bSortable": false, "aTargets": [ 0, -1 ] },
                { "bSearchable": false, "aTargets": [ 0, -1 ] },
                { "bVisible": false, "aTargets": [ "hide" ] },
                { "iDataSort": 4, "aTargets": [ 5 ] },
                { "sType": "string", "aTargets": [ 0 ] }
            ]
	});

	jQuery('#status_select').change( function() { 
		status_val = jQuery('#status_select').val();	

		window.location.href = window.location.href.replace( /[\?#].*|$/, "?status=" + status_val);																					
	} );

	$('#boulder_doubts .untick-link').click( function() {
		var input = $(this).parent().parent().find('input');
		if(!input.attr('checked'))
			input.trigger('click');
		return false;
	});
	
	$('#boulder_doubts .tick-link').click( function() {
		var input = $(this).parent().parent().find('input');
		if(!input.attr('checked'))
			//input.trigger('click');
			input.attr("checked", true);
		return false;
	});
});

function toggleDoubtStatus(doubt_id)
{
    $.ajax({
        url: '/boulder_doubts/'+doubt_id+'/togglecheck/',
        success: function (data) {
        	img_src = (data == '0') ? '/assets/levels/5.png' : '/assets/levels/3.png'
            $('#doubt_status_'+doubt_id + " img").attr('src', img_src);
        }
    });
}