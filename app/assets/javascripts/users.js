$(document).ready(function(event) {
    $('#roles-form-tooltip').tooltip({
	container: 'body',
	trigger: 'hover'
    });

    $("#ranked, #unranked").sortable({
	connectWith: ".connected-sortable"
    }).disableSelection();

    $("#ranked, #unranked").sortable({
	stop: function(e, ui) {
	    var dragged = $(ui.item.get());

	    dragged.parent().find("li").each(function(index, elt) {
		$(this).find("select").val(index + 1);
	    });

	    // If dropped into the bottom list, set its value to "No pref"

	    // In the controller, update _all_ items (in both lists). We'll
	    // need to ensure that the right ones end up in the right @lists,
	    // and inspect the params a bit...
	}
    });
});
