$(document).ready(function(){
	$('#colors').dataTable({
		bPaginate: false,
		bJQueryUI: true,
		bSortClasses: false,
		aaSorting: [[1, "asc"]],
		"aoColumnDefs": [
			{ "bSortable": false, "aTargets": [ -1, -2 ] },
			{ "bVisible": false, "aTargets": [ "hide" ] }
		]
	});
});