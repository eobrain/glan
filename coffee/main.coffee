$ ->

  #window.History.Adapter.bind window, 'statechange', () ->
  #  state = window.History.getState()
  #  window.History.log state.data, state.title, state.url

  $content = $ '#content'
  $nav     = $ ".nav"

  currentPage = ( ->
    currentPageId = 'home'

    #@setPage = (pageId) ->
    #  $('#'+currentPageId).css 'display', 'none'
    #  currentPageId = pageId
    #  $('#'+currentPageId).css 'display', 'block'

    $(window).on 'hashchange', ->
      $('#'+currentPageId).removeClass 'current'
      $('#menu-'+currentPageId).removeClass 'active'
      currentPageId = window.location.hash.substring 1
      $('#'+currentPageId).addClass 'current'
      $('#menu-'+currentPageId).addClass 'active'

  )()


  fetchPage = (pageId, children) ->
    $content.append "<article id='#{pageId}'></article>"
    $page = $ '#'+pageId
    $.get "site/pages/#{ pageId }.txt", (md) ->
      $page.append markdown.toHTML md
      list = '<ul>'
      for childId of children
        do (childId) ->
          list += "<li>#{ childId }</li>"
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
        #($nav.append "<li><a href='#'>#{ childId }</li>").click () ->
        #  #window.History.pushState {page:childId}, childId, '#'+childId
        #  window.location.hash = '#'+childId


  $.getJSON 'site/config.json', (config) ->
    $('head title').text config.title

  $.getJSON 'site/structure.json', (structure) ->
    setupTopNav structure
    walkStructure 'home', structure


