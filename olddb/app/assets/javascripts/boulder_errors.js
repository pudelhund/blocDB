$(document).ready(function(){
	$('#boulder_errors').dataTable({
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

		window.location.href =window.location.href.replace( /[\?#].*|$/, "?status=" + status_val);																					
	} );

    $('#boulder_errors a.show').click(function() {
        if (eval($('#logged_in').attr('value'))) {
            openModalDialog(this.href, {height: 500, width: 500, title: this.title});
        } else {
            alert('Du bist nicht eingeloggt!');
        }
        return false;
    });

});

function toggleErrorStatus(error_id)
{
    $.ajax({
        url: '/boulder_errors/'+error_id+'/togglecheck/',
        success: function (data) {
        	img_src = (data == '0') ? '/assets/levels/5.png' : '/assets/levels/3.png'
            $('#error_status_'+error_id + " img").attr('src', img_src);
        }
    });
}