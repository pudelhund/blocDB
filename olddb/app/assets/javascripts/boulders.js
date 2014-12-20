// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

done = false;
$(document).ready(function(){

    if (!done)
    {
    	$('#boulders').dataTable({
            bJQueryUI: true,
            bPaginate: false,
            bSortClasses: false,
            aaSorting: [[2, "asc"]],
            "aoColumnDefs": [
                { "bSortable": false, "aTargets": [ 0, -1, -2, -3, -4, -5 ] },
                { "bSearchable": false, "aTargets": [ -1, -2, -3, -4, -5 ] },
                { "bVisible": false, "aTargets": [ "hide" ] },
                { "iDataSort": 11, "aTargets": [ 12 ] },
                { "iDataSort": 13, "aTargets": [ 14 ] },
                { "iDataSort": 3, "aTargets": [ 4 ] },
                { "sType": "string", "aTargets": [ 1, 2, 6, 8 ] },
                { "sType": "numeric", "aTargets": [ 11 ] }
            ]
        });
        done = true;
    }


	$('a.comments-link').click(function() {
        openModalDialog(this.href, {height: 300, width: 500, title: "Kommentare zu: " + this.title});
        return false;
	});


    $('#boulders a.show').click(function() {
        if (eval($('#logged_in').attr('value'))) {
            openModalDialog(this.href, {height: 500, width: 500, title: this.title});
        } else {
            alert('Du bist nicht eingeloggt!');
        }
        return false;
    });


    $('a.show-climbers').click(function() {
        if (eval($('#logged_in').attr('value'))) {
            openModalDialog(this.href, {height: 600, width: 350, title: "Begeher"});
        } else {
            alert('Du bist nicht eingeloggt!');
        }
        return false;
    });


    $('#boulder_creator_ids').comboselect({
        addremall: false
    });

    $('a.tick-link').click(function(event){
        showTick(event, $(this));
        return false;
    });

    $('a#close-tick-popup').click(function(){
        $('#tick-popup').hide();
        return false;
    });

    $('a#tick-top').click(function(){
        tick($(this), 'top');
        return false;
    });

    $('a#tick-flash').click(function(){
        tick($(this), 'flash');
        return false;
    });

    $('a.untick-link').click(function(event){
        untick($(this));
        return false;
    });

    $('body').click(function(){
        $('#tick-popup').hide();
    });

        // Rating Stars
    $('.rating').raty({
        half  : true,
        readOnly : !eval($('#logged_in').attr('value')),
        noRatedMsg : 'Niemand hat diese Route bisher bewertet!',
        scoreName : $(this).attr('title'),
        score:  function() {
            return $(this).attr('data-rating');
        },
        click: function(score, evt) {
            alert("Sie haben die Route mit " + score + " bewertet!");
            if ($(this).parent().find('img.my-rating').length <= 0) {
                $(this).after('<img alt="Bullet_valid" class="my-rating" src="/assets/bullet_valid.png" title="Meine eigene Wertung: '+score+'">');
            }
            title = $(this).attr('title');
            title = title.replace(/Ich habe diese Route noch nicht bewertet\./, 'Meine eigene Wertung: '+score);
            $(this).attr('title', title);
            
            var boulderID = $(this).attr('boulder-id');

            $.ajax({
                url: '/boulders/'+boulderID+'/rate/'+score,
                ratyObject: this,
                success: function (data) {
                    $(this.ratyObject).raty('score', data);
                }
            });
        }
    });

    $('.rating img').removeAttr('title');
    $('.rating').tooltip();

    $('#boulders span.event-logos img').click(function(){
        event_id = $(this).attr('event_id');
        if (window.location.href.indexOf('?') != -1) {
            url = window.location.href.slice(0, window.location.href.indexOf('?'));
        } else {
            url = window.location.href;
        }
        window.location = url + '?filter=event&event_id=' + event_id;
    });

    $('a.error-link').click(function() {
        openModalDialog(this.href, {height: 300, width: 500, title: "Fehler melden"});
        return false;
    });


    if ($('#is_admin').attr('value') == 'true')
    {
        if ($('#theAllSelector').length == 0)
        {
            $('#boulders_info').parent().append(
                '<div class="massedit-toolbar">'+
                    '<select name="masseditOption" onchange="executeMassedit(this.value)">'+
                        '<option value="0">-- wählen --</option>'+
                        '<option value="set_mod">Modifiziert</option>'+
                        '<option value="remove_mod">Entferne Modifiziert</option>'+
                        '<option value="deactivate">Deaktiviern</option>'+
                    '</select>'+
                    '<input type="checkbox" id="theAllSelector" onclick="toggleSelectAll()"/>'+
                '</div>'
            );
        }
    }


	if ($("#boulders_filter").length > 0 && $("#table_filter_placeholder").length > 0)
	{
		$("#table_filter_placeholder").append($("#boulders_filter label"));
		$("#table_filter_placeholder").parent().parent().append($("#table_filter_placeholder"));
		$('#boulders_filter').remove();
	}
});

function showTick(event, link)
{
    $('#tick-popup').css('left', event.pageX);
    $('#tick-popup').css('top', event.pageY);
	$('#tick-popup').css('z-index', 3000);
    $('#tick-top').attr('boulder_id', $(link).attr('boulder_id'));
    $('#tick-top').attr('event_id', $(link).attr('event_id'));
    $('#tick-top').attr('user_id', $(link).attr('user_id'));
    $('#tick-top').attr('climbers', $(link).attr('climbers'));
	$('#tick-top').attr('own', $(link).attr('own'));
    $('#tick-flash').attr('boulder_id', $(link).attr('boulder_id'));
    $('#tick-flash').attr('event_id', $(link).attr('event_id'));
    $('#tick-flash').attr('user_id', $(link).attr('user_id'));
    $('#tick-flash').attr('climbers', $(link).attr('climbers'));
	$('#tick-flash').attr('own', $(link).attr('own'));
    $('#tick-popup').show();
}


function tick(link, type)
{
    var boulderID = $(link).attr('boulder_id');
    var eventID = $(link).attr('event_id');
    var userID = $(link).attr('user_id');
	var own = $(link).attr('own') == 'true' ? true : false;

	var ownUntickLinkID = 'untick_link_'+boulderID;
	var ownTickLinkID = 'tick_link_'+boulderID;
	
	var untickLinkID = 'untick_link_'+boulderID;
	var tickLinkID = 'tick_link_'+boulderID;
	if($(link).attr('climbers') == 'true')
	{
		untickLinkID = 'untick_link_climbers_'+boulderID+'_'+userID;
		tickLinkID = 'tick_link_climbers_'+boulderID+'_'+userID;
	}
	
    $.ajax({
        url: '/boulders/'+boulderID+'/tick/'+type+'/'+eventID+'/' + userID,
        success: function (data) {
            $('#boulder_points_'+boulderID).html(data);
        }
    });
    
    if (type == 'flash') {
        $('a#' + tickLinkID + ' img').attr('src', '/assets/lightning.png');
    } else {
        $('a#' + tickLinkID + ' img').attr('src', '/assets/accept.png');
    }
    $('a#' + tickLinkID).attr('class', 'untick-link');

    $('a#' + tickLinkID).unbind('click');
    $('a#' + tickLinkID).bind('click', function() {
        untick($(this));
        return false;
    });

    $('a#' + tickLinkID).attr('id', untickLinkID);
	
	if(own)
	{
		if (type == 'flash') {
			$('a#' + ownTickLinkID + ' img').attr('src', '/assets/lightning.png');
		} else {
			$('a#' + ownTickLinkID + ' img').attr('src', '/assets/accept.png');
		}
		$('a#' + ownTickLinkID).attr('class', 'untick-link');

		$('a#' + ownTickLinkID).unbind('click');
		$('a#' + ownTickLinkID).bind('click', function() {
			untick($(this));
			return false;
		});

		$('a#' + ownTickLinkID).attr('id', ownUntickLinkID);
	}
	
    $('#tick-popup').hide();
}


function untick(link)
{
    var boulderID = $(link).attr('boulder_id');
    var eventID = $(link).attr('event_id');
    var userID = $(link).attr('user_id');
	var own = $(link).attr('own') == 'true' ? true : false;
	
	var ownUntickLinkID = 'untick_link_'+boulderID;
	var ownTickLinkID = 'tick_link_'+boulderID;
	
	var untickLinkID = 'untick_link_'+boulderID;
	var tickLinkID = 'tick_link_'+boulderID;
	if($(link).attr('climbers') == 'true')
	{
		untickLinkID = 'untick_link_climbers_'+boulderID+'_'+userID;
		tickLinkID = 'tick_link_climbers_'+boulderID+'_'+userID;
	}

    $.ajax({
        url: '/boulders/'+boulderID+'/untick/'+eventID+'/' + userID,
        success: function (data) {
            $('#boulder_points_'+boulderID).html(data);
        }
    });

    $('a#' + untickLinkID + ' img').attr('src', '/assets/cross.png');
    $('a#' + untickLinkID).attr('class', 'tick-link');

    $('a#' + untickLinkID).unbind('click');
    $('a#' + untickLinkID).bind('click', function(event) {
        showTick(event, $(this));
        return false;
    });

    $('a#' + untickLinkID).attr('id', tickLinkID);
	
	if(own)
	{
	    $('a#' + ownUntickLinkID + ' img').attr('src', '/assets/cross.png');
		$('a#' + ownUntickLinkID).attr('class', 'tick-link');

		$('a#' + ownUntickLinkID).unbind('click');
		$('a#' + ownUntickLinkID).bind('click', function(event) {
			showTick(event, $(this));
			return false;
		});

		$('a#' + ownUntickLinkID).attr('id', ownTickLinkID);
	}
}

/*
 * Wurde durch die Massenbearbeitung ersetzt
 *
function toggleMod(boulderID)
{
    $.ajax({
        url: '/boulders/'+boulderID+'/togglemod',
        success: function (data) {
            $('#boulder_tags_'+boulderID).html(data);
        }
    });
}
*/

function submitComment(boulder_id, author_id)
{
    var comment = $('#comment_for_'+boulder_id).val();
    $.ajax({
        type: "POST",
        url: "/comments",
        data: "comment=" + escape(comment) + "&boulder_id=" + boulder_id + "&author_id=" + author_id,      
        success: function (data) {
            $('#dialog').html(data);
        },
    });
}

function submitErrorReport(boulder_id, author_id)
{
    var error = $('#error_for_'+boulder_id).val();
    $.ajax({
        type: "POST",
        url: "/boulder_errors",
        data: "error=" + escape(error) + "&boulder_id=" + boulder_id + "&user_id=" + author_id + "&status=1",      
        success: function (data) {
            $('#dialog').remove();
        },
    });
}


function toggleSelectAll()
{
    if ($('#theAllSelector').attr('checked')) {
        $('#boulders input[name="massedit"]').attr('checked', 'checked');
    } else {
        $('#boulders input[name="massedit"]').removeAttr('checked');
    }
}


function executeMassedit(action)
{
    if ($('#boulders input[name="massedit"]:checked').length == 0) {
        alert("Du hast keine Boulder gewählt!");
        return false;
    }

    boulderIDs = new Array();
    $('#boulders input[name="massedit"]:checked').each(function(){
        boulderIDs.push($(this).val());
    });
    
    $.ajax({
        type: "POST",
        url: "/boulders/massedit",
        data: "masseditaction=" + action + "&boulderIDs=" + boulderIDs.join(','),      
        success: function (data) {
            alert(data);
            location.href = location.href;
        },
    });
}