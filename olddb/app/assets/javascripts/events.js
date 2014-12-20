
$(document).ready(function(){

	$('#events').dataTable({
		bPaginate: false,
    	bJQueryUI: true,
    	bSortClasses: false,
		"aoColumnDefs": [
			{ "bSortable": false, "aTargets": [ -1, -2, -3 ] },
			{ "bVisible": false, "aTargets": [ "hide" ] },
    		{ "iDataSort": 3, "aTargets": [ 4 ] },
    		{ "iDataSort": 5, "aTargets": [ 6 ] }
    	]
	});

    $('#event_participant_ids').comboselect({
        addremall: false
    });

    $('#event_boulder_ids').comboselect();

    showHidePeriod();

    $('#event_period').click(function(){
        showHidePeriod();
    });

});


function showHidePeriod()
{
    if ($('#event_period').attr('checked') == 'checked') {
        $('#event_date_from_input').show();
        $('#event_date_to_input').show();
    } else {
        $('#event_date_from_input').hide();
        $('#event_date_to_input').hide();
    }
}