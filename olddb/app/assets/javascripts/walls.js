
$(document).ready(function(){

	$('#walls').dataTable({
		bPaginate: false,
    	bJQueryUI: true,
    	bSortClasses: false,
		"aoColumnDefs": [
			{ "bSortable": false, "aTargets": [ -1, -2 ] },
			{ "bVisible": false, "aTargets": [ "hide" ] }
    	]
	});

});