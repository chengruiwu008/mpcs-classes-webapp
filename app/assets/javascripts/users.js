$(document).ready(function(event) {
    var star = "<i class=\"fa fa-star\"></i>";
    var select = document.getElementById("user_number_of_courses");
    var num_courses = parseInt(select.options[select.selectedIndex].text);

    $("#ranked li .form-group").slice(0,num_courses).append(star);

    $('#roles-form-tooltip').tooltip({
	container: 'body',
	trigger: 'hover'
    });

    $("#ranked, #unranked").sortable({
	connectWith: ".connected-sortable"
    });

    function sort_ranks() {
	$("#ranked").find("li").each(function(index, elt) {
	    $(this).find("select").val(index + 1);
	});

	$("#ranked li .form-group").find('i').remove();
	$("#unranked li .form-group").find('i').remove();
	$("#ranked li .form-group").slice(0,num_courses).append(star);
    }

    // Change rank by dragging and dropping into ranked or unranked list
    $("#ranked, #unranked").sortable({
	stop: function(event, ui) {
	    var dragged = $(ui.item.get());

	    if (dragged.parent().attr("id") == "unranked") {
		dragged.find("select").val("No preference");
	    }

	    sort_ranks();
	}
    });

    // Change rank by selecting a value from the dropdown
    $("#ranked li, #unranked li").change(function (event) {
	var val = $(this).find("select").val();

	if (val == "No preference") {
	    $(this).prependTo("#unranked");
	} else {
	    if (val > $("#ranked li").length) {
		$(this).appendTo("#ranked");
	    } else {
		$(this).prependTo("#ranked");
	    }
	}

	$("#ranked").find("li").each(function(index, elt) {
	    $(this).find("select").val(index + 1);
	});

	sort_ranks();
    });

});
