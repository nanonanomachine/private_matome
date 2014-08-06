# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
	$('.create-item-list li, #item-create-cancel').click ->
		$('.item-form').children().attr('class', 'hide')
		$('.item-form textarea, :text, select').val('')
		$('div #' + this.id).attr('class', 'show')

$(document).ready(ready)
$(document).on('page:load', ready)