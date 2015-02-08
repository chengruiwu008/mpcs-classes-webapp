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
	    console.log(ui);
	    $(this).val("5");
	    console.log(ui.item.index());
	}
    });
});
