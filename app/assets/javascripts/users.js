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

	    // Change rank by dragging and dropping
	    if (dragged.parent().attr("id") == "unranked") {
		dragged.find("select").val("No preference");
	    }

	    $("#ranked").find("li").each(function(index, elt) {
		$(this).find("select").val(index + 1);
	    });

	    // In the controller, update _all_ items (in both lists). We'll
	    // need to ensure that the right ones end up in the right @lists,
	    // and inspect the params a bit...
	}
    });

    //$("#ranked, #unranked").something({
	// Change rank via the dropdown select
    //});
});
