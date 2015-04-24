class BList

  constructor: (@$el, @count) ->
    @playing = 0
    @next = 0
    @repeat = "none"


  fill: =>


  save: =>


  get_playing: =>


  set_playing: =>


  get_next: =>


class ListItem
  @youtube_url   = "http://gdata.youtube.com/feeds/api/videos"
  @youtube_query = "q=<%= videoid %>&format=5&max-results=1&v=2&alt=jsonc"
  @request

  constructor: (@$el, @code = 0, @number = 0, @title = '') ->

  set_code: (@code) =>
  set_title: (@title) =>

  get_code: => @code
  get_title: => @title

  build_youtube_path: (videoid) ->
    tpl  = _.template "#{@youtube_url}?#{@youtube_query}"
    path = tpl {videoid}

    return path


  request_data: (videoid) ->
    request_path = @build_youtube_path videoid
    @request     = $getJson request_path

    @request
      .done @on_request_done
      .fail @on_request_fail


  on_request_done: (data) ->
    title = data.data.items?[0].title


  on_request_fail: (data) ->


  render: (title, number) ->
    $li = 
