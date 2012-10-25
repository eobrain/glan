$ ->

  $.getJSON 'site/config.json', (config) ->
      $('head title').text config.title


  pagesFetched = (page) ->
    (children) ->
      console.log "pagesFetched(#{page})"

      for child in children
        do (child) ->
          fetchPage child

  $body = $ 'body'

  fetchPage = (page) ->
    $body.append "<h2>#{ page }</h2>"
    $body.append "<p id='#{page}'></p>"
    #$("##{page}").load "site/pages/#{ page }.txt"
    #$.get "site/pages/#{ page }.txt", (markdown) ->
    $.get "site/pages/#{ page }.txt", (md) ->
      #console.log "md=#{ md }=#{ JSON.stringify md }"
      console.log "html=#{ markdown.toHTML md }"
      $("##{page}").append markdown.toHTML md
    $.getJSON "site/pages/#{ page }.json", pagesFetched page

  fetchPage 'Home'


###

PageModel = Backbone.Model.extend
  urlRoot: 'site/config.json'


#page = new PageModel

ConfigModel = Backbone.Model.extend
  urlRoot: 'site/config.json'

config = new ConfigModel
config.fetch
  success: (c) ->
    $('head title').text c.get 'title'

PagesModel = Backbone.Model.extend
  urlRoot:  'site/pages'

home = new PagesModel
  id: 'Home.json'

pagesFetched = (pages) ->
  for page in pages
    alert "Page #{page}"
    page.fetch
      success: pagesFetched

home.fetch
  success: pagesFetched

###