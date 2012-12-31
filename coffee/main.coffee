###
# This file is part of the Glan CMS systemm.
# (c) Eamonn O'Brien-Strain  e@obrain.com
###

$ ->

  $content  = $ '#content'
  $children = $ '#children'
  $nav      = $ ".nav"
  $footer   = $ 'footer'

  ajaxCache = true

  #BEGIN singleton handle page navigation
  currentPage = new ( ->

    #get string following hash
    fromHash = () ->
       window.location.hash.substring 1

    currentPageId = fromHash()

    # go to home if no hash
    if !currentPage
      window.location.hash = '#home'
      currentPageId = fromHash()

    undisplay = ->
      $('.page-'+currentPageId).removeClass 'current'
      $('#menu-'+currentPageId).removeClass 'active'

    #fixFooter = ->
    #  console.log $(window).height()
    #  console.log $(document).height()
    #  if $(window).height() < $(document).height()
    #    $footer.addClass 'at-bottom'
    #  else
    #    $footer.removeClass 'at-bottom'

    display = ->
      $('.page-'+currentPageId).addClass 'current'
      $('#menu-'+currentPageId).addClass 'active'
      #window.setTimeout fixFooter, 1

    changePageTo = (newPageId) ->
      undisplay()
      currentPageId = newPageId
      display()

    $(window).on 'hashchange', ->
      changePageTo window.location.hash.substring 1

    #end private, begin public

    @displayIf = (pageId) ->
      if pageId == currentPageId
        display()

    null
  )
  #END singleton



  loadMarkDown = (url, $element, pageId) ->
    $.ajax
      url:     url
      cache:   ajaxCache
      success: (md) ->
        $element.append markdown.toHTML md
        if pageId
          title = $(".page-#{ pageId } h1").text()
          if title
            $('.title-'+pageId).text title


  link = (pageId) ->
    "<a class='title-#{ pageId }' href='##{ pageId }'>#{ pageId }</a>"

  fetchPage = (pageId, children) ->
    $content.append "<article class='page-#{pageId}'></article>"
    $page = $ '.page-'+pageId
    loadMarkDown "site/pages/#{ pageId }.txt", $page, pageId
    if pageId != 'home' && _.size(children) > 0
      lis = _.map children, (grandChildren, childId) ->
        "<li>#{ link childId }</li>"
      cat = _.reduce  lis, ((list,item) -> list+item),  ''
      $children.append "<nav class='well page-#{pageId}'><ul>"+cat+'</ul></nav>'


  # Recursive funtion to walk down the structure.json tree
  walkStructure = (pageId, children) ->
    fetchPage pageId, children
    currentPage.displayIf pageId
    _.each children, (grandChildren, childId) ->
      walkStructure childId, grandChildren

  setupTopNav = (home) ->
    _.each home, (grandChildren, childId) ->
        ($nav.append "<li>#{ link childId }</li>").click () ->
          #$('#title='+childId).addClass 'active'
          $('.title-'+childId).addClass 'active'


  $.getJSON 'site/config.json', (config) ->
    $('head title').text config.title
    ajaxCache = config.ajaxCache

  $.getJSON 'site/structure.json', (structure) ->
    setupTopNav structure
    walkStructure 'home', structure

  loadMarkDown 'site/footer.txt', $ '#footer'
