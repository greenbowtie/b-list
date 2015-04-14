requirejs.config
  paths:
    "jquery"     : "bower_components/jquery/dist/jquery"
    "lodash"     : "bower_components/lodash/lodash"
    "handlebars" : "bower_components/handlebars/handlebars"

define ["jquery", "lodash", "handlebars"], ($, _, Hb) ->

  $list   = $("[js-list]")
  $input  = $("[js-input]")
  $output = $("[js-output]")
  $button = $("[js-button]")

  youtube_url = "http://gdata.youtube.com/feeds/api/videos?q="
  youtube_data = {
    format: 5
    "max-results": 1
    v: 2
    alt: "json"
  }

  # this is implicitly returned by coffee-script.
  self = {

    init: ->
      $button.on "click", self.clicked

      self.fill_from_local()

    fill_from_local: ->
      $input.val( localStorage["input"] )

    clicked: (e) ->
      val = $input.val()

      if val
        self.process val
        self.save val

      else
        self.die "no ticket"

    process: (val) ->
      urls = self.strip val

      if urls
        self.fill_list $list, urls
        self.fill_output $output, urls
      else
        self.die "wrong ticket"

    save: (val) ->
      localStorage["input"] = val

    strip: (text) ->
      pattern = /(((http(s)?:\/\/)?)(www\.)?((youtube\.com\/)|(youtu\.be)|(youtube)).[^ ]+)/g
      matches = text.match pattern


    fill_list: ($list, items) ->
      _.forEach items, (item, n) ->
        li = $("<li />").text item
        $list.append li
        false

    fill_output: ($target, urls) ->
      $target.val urls.join "\n"

    die: (why) ->
      alert "#{why}"

  }
