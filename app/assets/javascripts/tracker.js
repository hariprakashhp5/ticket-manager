$(document).on('ready page:load', function(){


$('tr').hover(function(){
$(this).addClass('hover');
}, function() {
	$(this).removeClass('hover');
});

$('tr:odd').addClass('odd')
$('tr:even').addClass('even')



});

