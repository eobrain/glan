$ ->
  parity = 0
  $imgs = [ $('#rotimg-odd'), $('#rotimg-even') ]
  imgdir = $imgs[parity].attr 'data-imgdir'
  $.getJSON imgdir+'/images.json', (images) ->
    if images[images.length-1] == null
      images.pop()
    n = images.length
    i = 0
    showImg = ->
      $imgs[parity].fadeOut 'slow'
      parity = 1-parity
      $imgs[parity].attr 'src', "#{ imgdir }/#{ images[i] }"
      $imgs[parity].fadeIn 'slow'
      i = (i+1) % n
    showImg()
    $(window).on 'hashchange', showImg
