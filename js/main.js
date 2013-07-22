
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
    var $children, $content, $nav, ajaxCache, currentPage, fetchPage, fromHash, link, loadMarkDown, setupTopNav, walkStructure;
    fromHash = function() {
      return window.location.hash.substring(1);
    };
    $content = $('#content');
    $children = $('#children');
    $nav = $(".nav");
    ajaxCache = true;
    currentPage = new (function() {
      var changePageTo, currentPageId, display, undisplay;
      currentPageId = fromHash();
      undisplay = function() {
        $('.page-' + currentPageId).slideUp('fast', function() {
          return $(this).removeClass('current');
        });
        return $('#menu-' + currentPageId).slideUp('fast', function() {
          return $(this).removeClass('active');
        });
      };
      display = function() {
        $('.page-' + currentPageId).slideDown('fast', function() {
          return $(this).addClass('current');
        });
        return $('#menu-' + currentPageId).slideDown('fast', function() {
          return $(this).addClass('active');
        });
      };
      changePageTo = function(newPageId) {
        undisplay();
        currentPageId = newPageId;
        return display();
      };
      this.displayIf = function(pageId) {
        if (pageId === currentPageId) return display();
      };
      if (!currentPageId) {
        window.location.hash = '#home';
        currentPageId = fromHash();
      }
      $(window).on('hashchange', function() {
        return changePageTo(window.location.hash.substring(1));
      });
      return null;
    });
    loadMarkDown = function(url, $element, pageId) {
      return $.ajax({
        url: url,
        cache: ajaxCache,
        success: function(md) {
          var title;
          $element.append(markdown.toHTML(md));
          if (pageId) {
            title = $(".page-" + pageId + " h1").text();
            if (title) return $('.title-' + pageId).text(title);
          }
        },
        error: function(jqXHR, textStatus, errorThrown) {
          if (jqXHR.status === 404) {
            return alert("Web site is misconfigured:\n  There is an entry for \"" + pageId + "\" in structure.json\n  but there is no file \"" + url + "\"");
          }
        }
      });
    };
    link = function(pageId) {
      return "<a class='title-" + pageId + "' href='#" + pageId + "'>" + pageId + "</a>";
    };
    fetchPage = function(pageId, children) {
      var $page, cat, lis;
      $content.append("<article class='page-" + pageId + "'></article>");
      $page = $('.page-' + pageId);
      loadMarkDown("site/pages/" + pageId + ".txt", $page, pageId);
      if (pageId !== 'home' && _.size(children) > 0) {
        lis = _.map(children, function(grandChildren, childId) {
          return "<li>" + (link(childId)) + "</li>";
        });
        cat = _.reduce(lis, (function(list, item) {
          return list + item;
        }), '');
        return $children.append(("<nav class='well page-" + pageId + "'><ul>") + cat + '</ul></nav>');
      }
    };
    walkStructure = function(pageId, children) {
      fetchPage(pageId, children);
      currentPage.displayIf(pageId);
      return _.each(children, function(grandChildren, childId) {
        return walkStructure(childId, grandChildren);
      });
    };
    setupTopNav = function(home) {
      return _.each(home, function(grandChildren, childId) {
        return ($nav.append("<li>" + (link(childId)) + "</li>")).click(function() {
          return $('.title-' + childId).addClass('active');
        });
      });
    };
    $.getJSON('site/config.json', function(config) {
      $('head title').text(config.title);
      $('#logo').attr('src', config.logo);
      return ajaxCache = config.ajaxCache;
    });
    $.getJSON('site/structure.json', function(structure) {
      setupTopNav(structure);
      return walkStructure('home', structure);
    });
    loadMarkDown('site/footer.txt', $('#footer'));
    return loadMarkDown('README.md', $('.page-GLAN'));
  });

}).call(this);
