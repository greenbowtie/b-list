requirejs.config
  paths:
    "jquery"     : "bower_components/jquery/dist/jquery"
    "lodash"     : "bower_components/lodash/lodash"
    "handlebars" : "bower_components/handlebars/handlebars"
    "bootstrap"  : "bower_components/bootstrap-sass/assets/javascripts/bootstrap"
    "sortable"   : "bower_components/Sortable/Sortable"
    "youtube"    : "https://www.youtube.com/iframe_api?noex"

  shim:
    "bootstrap"  : deps: ['jquery']
    "youtube"    : exports: "YT"

define ["jquery", "lodash", "handlebars", "bootstrap", "sortable", "youtube"],
($, _, Hb, bs, S, YT) ->

  $b_list          = $("[js-b-list]")
  $player          = $("[js-player]")
  $input           = $("[js-input]")
  $output          = $("[js-output]")
  $button          = $("[js-button]")
  $b_list_template = $("[js-b-list-template]")
  youtube_url      = "http://gdata.youtube.com/feeds/api/videos?q=<%= code %>&format=5&max-results=1&v=2&alt=jsonc"

  YTPlayer = ''
  STARTED_PLAYBACK = false;

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
        self.save val

        self.empty_output()
        self.process val


      else
        self.die "no ticket"

    process: (val) ->
      urls = self.strip val

      if urls
        self.fill_output $output, urls
        self.fill_list $b_list, urls

        sortable = S.create $b_list.get(0), {
          ghostClass: "floating"
        }

      else
        self.die "wrong ticket"

    save: (val) ->
      localStorage["input"] = val

    strip: (text) ->
      pattern = /(((http(s)?:\/\/)?)(www\.)?((youtube\.com\/)|(youtu\.be)|(youtube)).+[^\s])/g
      matches = text.match pattern

    get_playing: ($ul) ->
      playing = $ul.find ".playing"
      index = $ul.find("li").index playing

    get_next: ($ul) ->
      next = (self.get_playing $ul) + 1
      next = 0 if next = $ul.children().length

    set_playing: ($li) ->
      $li.parent().find(".playing").addClass "disabled"
      $li.siblings().removeClass "playing"
      $li.addClass "playing"
      STARTED_PLAYBACK = true;

    start_playback: ->
      start  = self.get_playing($b_list) + 1
      $start = $b_list.find('li')?.eq start
      this.play $start

    play: ($li) ->
      videoId = $li.data 'code'
      that = self

      events = {
        onStateChange: (e) ->
          if e.data == YT.PlayerState.ENDED
            next = self.get_next $b_list
            $next = $b_list.find('li').eq next
            that.play $next
      }

      playerVars = {
        autoplay: 1
      }

      data = {
        width: "100%"
        height: 40
        videoId
        events
        playerVars
      }

      if YTPlayer
        YTPlayer.loadVideoById videoId
      else
        YTPlayer = new YT.Player 'js-b-list-player', data

      self.set_playing($li)

    fill_list: ($ul, items) ->
      _.forEach items, (item, n) ->
        code     = self.get_code item
        template = Hb.compile $b_list_template.html()
        num      = n
        count    = n + 1
        tdata    = {item,code,num,count,$ul}

        if code
          self.get_youtube_data code, num

          html = template tdata
          $ul.append html


          self.start_playback() if not STARTED_PLAYBACK

    fill_output: ($target, urls) ->
      $target.val urls.join "\n"

    empty_output: ->
      $output.val ""

    get_code: (url) ->
      pattern = /(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/ ]{11})/i
      matches = url.match pattern
      return matches?[1]

    get_youtube_data: (code, num) ->
      tpl = _.template youtube_url
      url = tpl {code}
      req = $.getJSON url

      req.done (data) ->
        self.add_title data.data.items?[0].title, num

    add_title: (title, num) ->
        $li = $b_list.find("[data-num=#{num}]")
        $li.find('[js-title]').text title


    die: (why) ->
      alert "#{why}"

  }
