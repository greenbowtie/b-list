requirejs.config
  paths:
    "jquery": "bower_components/jquery/dist/jquery"
    "lodash": "bower_components/lodash/lodash"

define ["jquery", "lodash"], ($, _) ->

  $list = $("[js-list]")
  $input = $("[js-input]")
  $output = $("[js-output]")
  $button = $("[js-button]")

  self =
    init: ->
      $button.on "click", self.clicked

    clicked: (e) ->
      val = $input.val()

      if val
        self.process val

      else
        self.die "no ticket"

    process: (val) ->
      urls = self.strip val

      if urls
        self.fill_list $list, urls
        self.fill_output $output, urls
      else
        self.die "wrong ticket"

    strip: (text) ->
      pattern = /(((http(s)?:\/\/)?)(www\.)?((youtube\.com\/)|(youtu\.be)|(youtube)).[^ ]+)/g
      matches = text.match pattern

    fill_list: ($list, items) ->
      _.forEach items, (item, n) ->
        li = $("<li />").text item
        $list.append li

    fill_output: ($output, urls) ->

    die: (why) ->
      alert "#{why}"

  return self
