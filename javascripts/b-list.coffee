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
  constructor: (@code, @number, @title) ->

  set_code: (@code) =>

  get_code: => @code

  set_title: (@title) =>

  get_title: => @title

  request_data: (videoid) ->

  on_request_done: (data) ->

  on_request_fail: (data) ->
