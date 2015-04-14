requirejs.config
  paths:
    "jquery"     : "bower_components/jquery/dist/jquery"
    "lodash"     : "bower_components/lodash/lodash"
    "echo"       : "bower_components/echojs/dist/echo"
    "handlebars" : "bower_components/handlebars/handlebars"
    "bootstrap"  : "bower_components/bootstrap-sass/assets/javascripts/bootstrap"

  shim:
    "bootstrap"  : deps: ['jquery']

define ["jquery", "lodash", "handlebars", "bootstrap", "echo"], ($, _, Hb, bs, echo) ->

  $list          = $("[js-list]")
  $input         = $("[js-input]")
  $output        = $("[js-output]")
  $button        = $("[js-button]")
  $list_template = $("[js-list-template]")

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
        template = Hb.compile $list_template.html()
        data = {
          item: item
          in_class: -> n is 0
          num: n
          code: self.get_code item
        }

        html = template data

        $list.append html

        # @TODO this didn't work. Lazyload better.
        echo.init()

    fill_output: ($target, urls) ->
      $target.val urls.join "\n"

    get_code: (url) ->
      pattern = /(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/ ]{11})/i
      matches = url.match pattern

      return matches[1]

    die: (why) ->
      alert "#{why}"

  }
