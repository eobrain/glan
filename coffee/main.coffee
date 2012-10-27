$ ->

  $content = $ '#content'
  $nav     = $ ".nav"

  currentPage = ( ->
    currentPageId = 'home'

    changePageTo = (newPageId) ->
      $('#'+currentPageId).removeClass 'current'
      $('#menu-'+currentPageId).removeClass 'active'
      currentPageId = newPageId
      $('#'+currentPageId).addClass 'current'
      $('#menu-'+currentPageId).addClass 'active'

    $(window).on 'hashchange', ->
      changePageTo window.location.hash.substring 1

    window.location.hash = '#'+currentPageId
    changePageTo currentPageId

  )()


  fetchPage = (pageId, children) ->
    $content.append "<article id='#{pageId}'></article>"
    $page = $ '#'+pageId
    $.get "site/pages/#{ pageId }.txt", (md) ->
      $page.append markdown.toHTML md
      list = '<ul>'
      for childId of children
        do (childId) ->
          list += "<li><a href='##{ childId }'>#{ childId }</a></li>"
      list += '</ul>'
      $page.append list



  walkStructure = (pageId, children) ->
    fetchPage pageId, children
    for childId, grandchildren of children
      do (childId, grandchildren) ->
        walkStructure childId, grandchildren

  setupTopNav = (home) ->
    for childId of home
      do (childId) ->
        ($nav.append "<li><a href='##{ childId }'>#{ childId }</li>").click () ->


  $.getJSON 'site/config.json', (config) ->
    $('head title').text config.title

  $.getJSON 'site/structure.json', (structure) ->
    setupTopNav structure
    walkStructure 'home', structure


