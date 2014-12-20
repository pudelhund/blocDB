$(document).ready(function(){

	$('#locations').dataTable({
		bPaginate: false,
    	bJQueryUI: true,
    	bSortClasses: false,
		"aoColumnDefs": [
			{ "bSortable": false, "aTargets": [ -1, -2, -3 ] },
			{ "bVisible": false, "aTargets": [ "hide" ] }
    	]
	});
	
	
	$('#locationsCarousel').carousel({
		interval: false		
	}).on('slide', function(e){
		$('#locationContent .row').hide();
	}).on('slid', function(e){
		index = $(this).find('.active').attr('data-index');
		$('#locationContentBox_'+index).show();
	});
 
});