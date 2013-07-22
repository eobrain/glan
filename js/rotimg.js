
/*
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
*/

(function() {

  $(function() {
    var $imgs, imgdir, parity;
    parity = 0;
    $imgs = [$('#rotimg-odd'), $('#rotimg-even')];
    imgdir = $imgs[parity].attr('data-imgdir');
    return $.getJSON(imgdir + '/images.json', function(images) {
      var i, n, showImg;
      if (images[images.length - 1] === null) images.pop();
      n = images.length;
      i = 0;
      showImg = function() {
        $imgs[parity].fadeOut('slow');
        parity = 1 - parity;
        $imgs[parity].attr('src', "" + imgdir + "/" + images[i]);
        $imgs[parity].fadeIn('slow');
        return i = (i + 1) % n;
      };
      showImg();
      return $(window).on('hashchange', showImg);
    });
  });

}).call(this);
