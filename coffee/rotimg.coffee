$ ->
  $img = $ '#rotimg'
  imgdir = $img.attr 'data-imgdir'
  $.getJSON imgdir+'/images.json', (images) ->
    if images[images.length-1] == null
      images.pop()
    n = images.length
    i = 0
    showImg = ->
      $img.attr 'src', "#{ imgdir }/#{ images[i] }"
      i = (i+1) % n
    showImg()
    $(window).on 'hashchange', showImg



