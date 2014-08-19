# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
	getLinkItemImageInfo = ->
		[thumb_image = $('#item-image-thumb'), parseInt(thumb_image.data('index'))]

	setLinkItemImage = (elm, index, src, length) ->
		elm.attr('src', src)
		$('#image-remote-url').val(src)
		$('#item-image-num').text(index + 1 + "/" + length)
		elm.data('index', index)

	$(document).on 'click', '#item-image-next', ->
		imageInfo = getLinkItemImageInfo()
		thumb_image = imageInfo[0]
		index = imageInfo[1]
		if index == window.image_urls.length - 1
			index = 0
		else
			index++
		setLinkItemImage(thumb_image, index, window.image_urls[index], window.image_urls.length)
		false
	
	$(document).on 'click', '#item-image-prev', ->
		imageInfo = getLinkItemImageInfo()
		thumb_image = imageInfo[0]
		index = imageInfo[1]
		if index == 0
			index = window.image_urls.length - 1
		else
			index--
		setLinkItemImage(thumb_image, index, window.image_urls[index], window.image_urls.length)
		false
	
$(document).ready(ready)
$(document).on('page:load', ready)