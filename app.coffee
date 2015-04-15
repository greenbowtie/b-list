requirejs.config
  paths:
    "jquery"     : "bower_components/jquery/dist/jquery"
    "lodash"     : "bower_components/lodash/lodash"
    "handlebars" : "bower_components/handlebars/handlebars"
    "bootstrap"  : "bower_components/bootstrap-sass/assets/javascripts/bootstrap"
    "sortable"   : "bower_components/Sortable/Sortable"

  shim:
    "bootstrap"  : deps: ['jquery']

define ["jquery", "lodash", "handlebars", "bootstrap", "sortable"],
($, _, Hb, bs, S) ->

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
        self.empty_everything()
        self.process val
        self.save val
        console.log "playing: #{self.get_playing($list)}"
      else
        self.die "no ticket"

    process: (val) ->
      urls = self.strip val

      if urls
        self.fill_output $output, urls
        self.fill_list $list, urls

        sortable = S.create $list.get(0), {
          ghostClass: "disabled"
        }

      else
        self.die "wrong ticket"

    save: (val) ->
      localStorage["input"] = val

    strip: (text) ->
      pattern = /(((http(s)?:\/\/)?)(www\.)?((youtube\.com\/)|(youtu\.be)|(youtube)).[^ ]+)/g
      matches = text.match pattern

    get_playing: ($el) ->
      playing = $el.find ".playing"
      index = $el.find("li").index playing

    fill_list: ($list, items) ->
      _.forEach items, (item, n) ->
        template = Hb.compile $list_template.html()
        data = {
          item: item
          code: self.get_code item
          playing: if n is 0 then "playing" else ""
          num: n
          count: n + 1
        }

        html = template data

        $list.append html

        # @TODO this didn't work. Lazyload better.
        # echo.init()

    fill_output: ($target, urls) ->
      $target.val urls.join "\n"

    empty_everything: ->
      $list.empty()
      $output.val ""

    get_code: (url) ->
      pattern = /(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/ ]{11})/i
      matches = url.match pattern

      return matches[1]

    die: (why) ->
      alert "#{why}"

  }
