$ ->

  $content  = $ '#content'
  $children = $ '#children'
  $nav      = $ ".nav"
  $footer   = $ 'footer'

  #BEGIN dingleton
  currentPage = new ( ->

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
    $.get url, (md) ->
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
    list = "<nav class='well page-#{pageId}'><ul>"
    for childId of children
      do (childId) ->
        list += "<li>#{ link childId }</li>"
    list += '</ul></nav>'
    $children.append list


  # Recursive funtion to walk down the structure.json tree
  walkStructure = (pageId, children) ->
    fetchPage pageId, children
    currentPage.displayIf pageId
    for childId, grandchildren of children
      do (childId, grandchildren) ->
        walkStructure childId, grandchildren

  setupTopNav = (home) ->
    for childId of home
      do (childId) ->
        ($nav.append "<li>#{ link childId }</li>").click () ->


  $.getJSON 'site/config.json', (config) ->
    $('head title').text config.title

  $.getJSON 'site/structure.json', (structure) ->
    setupTopNav structure
    walkStructure 'home', structure

  loadMarkDown 'site/footer.txt', $ '#footer'


