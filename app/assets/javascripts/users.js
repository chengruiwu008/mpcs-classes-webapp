$(document).ready(function(event) {
    $('#roles-form-tooltip').tooltip({
	container: 'body',
	trigger: 'hover'
    });

    $("#ranked, #unranked").sortable({
	connectWith: ".connected-sortable"
    }).disableSelection();

    function sort_ranks() {
	$("#ranked").find("li").each(function(index, elt) {
	    $(this).find("select").val(index + 1);
	});
    }

    // Change rank by dragging and dropping into ranked or unranked list
    $("#ranked, #unranked").sortable({
	stop: function(e, ui) {
	    var dragged = $(ui.item.get());

	    if (dragged.parent().attr("id") == "unranked") {
		dragged.find("select").val("No preference");
	    }

	    sort_ranks();
	}
    });

    // Change rank by selecting a value from the dropdown
    $("#ranked li, #unranked li").change(function () {
	var val = $(this).find("select").val();

	if (val == "No preference") {
	    $(this).insertBefore("#unranked li:first-child");
	} else {
	    if (val > $("#ranked li").length) {
		$(this).insertAfter("#ranked li:last-child");
	    } else {
		$(this).insertBefore("#ranked li:nth-child("+val+")");
	    }
	}

	sort_ranks();
    });

    $("#ranked").find("li").each(function(index, elt) {
	var star = "<span class='glyphicon glyphicon-align-left' aria-hidden='true'></span>"
	$(this).find(".form-group").append(star);
    });
});
