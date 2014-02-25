###
# This file is part of the Glan system http://glawn.org
#
# Copyright (c) 2012,2013 Eamonn O'Brien-Strain All rights
# reserved. This program and the accompanying materials are made
# available under the terms of the Eclipse Public License v1.0 which
# accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
#
# Contributors:
#    Eamonn O'Brien-Strain  e@obrain.com - initial author
###

assert = (cond) ->
  value = cond()
  msg = "#{cond} is #{value}"
  if value
    console.log "Assertion passed: #{msg}"
  else
    console.log "ASSERTION FAILED: #{msg}"


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
      $imgOld = $imgs[parity]
      $imgOld.fadeOut 600, ->
        $imgOld.css 'display', 'none'
      parity = 1-parity
      $imgNew = $imgs[parity]
      $imgNew.attr 'src', "#{ imgdir }/#{ images[i] }"
      $imgNew.fadeIn 600
      i = (i+1) % n

      #assert -> ($imgOld.css 'display')=='inline'
      #assert -> ($imgNew.css 'display')=='none'
      laterAssert = ->
        console.log "TEST: #{$imgOld.attr 'id'} #{$imgOld.css 'display'} == 'none'"
        assert -> ($imgOld.css 'display')=='none'
      setTimeout laterAssert, 700

    showImg()
    $(window).on 'hashchange', showImg
