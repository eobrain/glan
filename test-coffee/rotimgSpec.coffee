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

#wait until page is loaded
$ ->

  $imgOdd  = $ '#rotimg-odd'
  $imgEven = $ '#rotimg-even'

  describe 'rotimg is a plugin to Glan that rotates through a set of images', ->

    it 'initially, odd image is displayed and even image is not', ->

      runs ->
        #ajax has not jet returned the images.json
        expect($imgOdd.css 'display').not.toBe 'none'
      waitsFor ->
        ($imgOdd.css 'display') == 'none'
      runs ->
        expect($imgEven.css 'display').toBe 'inline'
        expect($imgOdd.css  'display').toBe 'none'

    it 'each hash change swaps what image is displayed', ->

      #check display status is as expected
      expectEvenOdd = (displayEven, displayOdd) ->
        expect($imgOdd.css  'display').toBe displayOdd
        expect($imgEven.css 'display').toBe displayEven

      runs ->
        expectEvenOdd 'inline', 'none'
        window.location.hash = '#aaa'
      waits 800
      runs ->
        expectEvenOdd 'none', 'inline'
        window.location.hash = 'bbb'
      waits 800
      runs ->
        expectEvenOdd 'inline', 'none'
        window.location.hash = '#ccc'
      waits 800
      runs ->
        expectEvenOdd 'none', 'inline'



    it 'image changes on every hashchange', ->

      $activeImg = ->
        if ($imgOdd.css 'display') == 'inline'
          $imgOdd
        else
          $imgEven

      pastUrls = []

      runs ->
        url = $activeImg().attr 'src'
        expect(pastUrls).not.toContain url
        pastUrls.push url
        window.location.hash = '#xxx'
      waits 800
      runs ->
        url = $activeImg().attr 'src'
        expect(pastUrls).not.toContain url
        pastUrls.push url
        window.location.hash = '#yyy'
      waits 800
      runs ->
        url = $activeImg().attr 'src'
        expect(pastUrls).not.toContain url
        pastUrls.push url
        window.location.hash = '#zzz'
      waits 800
      runs ->
        url = $activeImg().attr 'src'
        expect(pastUrls).not.toContain url
        pastUrls.push url
        window.location.hash = '#ppp'
      waits 800
      runs ->
        url = $activeImg().attr 'src'
        expect(pastUrls).not.toContain url
        pastUrls.push url
        window.location.hash = '#qqq'
      waits 800
      runs ->
        url = $activeImg().attr 'src'
        expect(pastUrls).not.toContain url
        pastUrls.push url
        window.location.hash = '#rrr'
      waits 800
      runs ->
        url = $activeImg().attr 'src'
        expect(pastUrls).not.toContain url
        pastUrls.push url
        window.location.hash = 'sss'
