$(document).ready(function(){

	var oTable = $('#rankings').dataTable({
		bPaginate: false,
    	bJQueryUI: true,
    	bSortClasses: false,
		"aoColumnDefs": [
			{ "bSortable": false, "aTargets": [ -1, -2, -3, -4, -5, -6 ] },
			{ "bVisible": false, "aTargets": [ "hide" ] }
    	]
	}).rowGrouping({sGroupingColumnSortDirection: "desc"});

	jQuery('.navbar #group_select').change( function() { 
		select_val = jQuery(this).val();	

		if (select_val == "Alle" || select_val == '') {
			window.location.href = window.location.href.replace( /[\?#].*|$/, "" );					
		} else {
			window.location.href =window.location.href.replace( /[\?#].*|$/, "?gender=" + select_val);											
		}
	} );

	// Bei 100% muss ein "z" vorne ran, da sonst beim sortieren (da alphanumerisch soritert wird) die 100% am Ende stehen. Das "z" wird hier wieder weg gemacht
	$('#rankings td.group').each(function(){
		if ($(this).html() == 'z100%') {
			$(this).html('100%');
		}
	});

});

