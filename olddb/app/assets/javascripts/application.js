// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require dataTables/jquery.dataTables
//= require bootstrap
//= require_tree .
$(document).ready(function(){
	$("input[type=submit],button[type=submit]").addClass('btn btn-info');
	
	$("input[class=date-input]").datepicker({ 
		dateFormat: "yy-mm-dd",
		changeYear: true,
		yearRange: "2008:2100"
	});

    // Verlagert die Suchbox der DataTables in die Navbar
    if($('.dataTables_filter input').length != 0)
    {
        $('.navbar-functions .navbar-inner')
            .append('<div class="input-prepend pull-right"><span class="add-on"><i class="icon-search"></i></span></div>');
        $('.dataTables_filter input').addClass('span2');
        $('.dataTables_filter input').attr("placeholder", "Suchen").blur();
        $('.dataTables_filter input').appendTo('.navbar-functions .navbar-inner .input-prepend');
        $('.fg-toolbar').first().remove();
    }

    // 40px Border nur auf nicht-mobile devices (fixed navbar funktioniert nicht auf mobile)
    if( ! /Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent) ) 
    {
        $('body').css('padding-top', '40px');
    }

    // dropdown fix
    $('a.dropdown-toggle, .dropdown-menu a').on('touchstart', function(e) {
      e.stopPropagation();
    });
	
	attachClickToUserCompareSelect();
});

function attachClickToUserCompareSelect()
{
	jQuery('#user_compare_id').change( function() { 
		
		select_val = jQuery(this).val();	
		if (select_val == '') {
			$(this).preventDefault();
			return false;
		} else {
			window.location.href = "/users/" + $('#current_user_id').attr('value') + "/compareto/" + select_val;					
		}
		$(this).preventDefault();
	} );
}

function openModalDialog(url, params)
{
	var dialog = $("#dialog");
    if ($("#dialog").length == 0) {
        dialog = $('<div id="dialog" style="display:hidden"></div>').appendTo('body');
    }

    params['modal'] = true;
    params['close'] = function(event, ui) {     
        dialog.remove();
    };

    dialog.dialog(params);

    if(params['title'] == 'Begeher')
    {
        dialog.load(url, function() {
			// untick links mit click belegen (fuer admin)
            $('#dialog a.untick-link').click(function(event){
                untick($(this));
                return false;
            });
			
			// anzweifeln links mit click belegen
			$('a.doubt-link').click(function() {
				openModalDialog(this.href, {height: 300, width: 500, title: "Leistung anzweifeln"});
				return false;
			});
        });
    }
    else
        dialog.load(url);


    return dialog;
}