function setLocationSelectClickHandlers()
{
	$('.select-location').click(function(e)
	{
		e.preventDefault();
		url = $(this).attr('href');
		var location_index = $(this).attr('location-index');
		$.ajax({
			type: 'POST',
			url: url,
			success: function(returnData)
			{
				$("#dialog").dialog('close');
				// TODO: slide carousel to selected location
				$('.carousel').carousel(parseInt(location_index));  
				
			}
		});
	});
}

$(document).ready(function()
{
	/*var start_index = $('.carousel').attr('start-index');
	$('.carousel').carousel(parseInt(start_index));  */

	$('#locationsCarousel').on('slid.bs.carousel', function() {
		var active = $('#locationContent .active');
		var index = $('.carousel-inner .active').attr('data-index');
		$(active).removeClass('active');
		$(active).fadeOut();
		$('#locationContentBox_'+index).addClass('active');
		$('#locationContentBox_'+index).fadeIn();
		
	});
});