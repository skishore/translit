class Typing
  constructor: ->
    @show_guides = false
    do @reset
    do @force_redraw

  reset: ->
    @segments = do @get_segments
    @answers = (REVERSE_TRANSLITERATIONS[segment] for segment in @segments)
    @entries = ('' for segment in @segments)
    @guides = (@show_guides for segment in @segments)
    @length = 0
    for segment in @segments
      @length += segment.length
    @i = 0

  force_redraw: ->
    data = {segments: []}
    for segment, i in @segments
      data.segments.push
        segment: segment
        entry: @get_entry_data i
        class: if @entries[i] == @answers[i] then 'correct' else undefined
        width: (Math.floor 100*segment.length/@length) + '%'
    Session.set 'typing', data

  get_segments: ->
    (Math.randelt Steps.ALPHABET for _ in [0...Math.randint 3, 6])

  get_entry_data: (i) ->
    cursor = undefined
    guide = if @guides[i] then @answers[i].slice @entries[i].length else ''
    cursor = undefined
    if i == @i
      cursor = guide[0] or ''
      guide = guide.slice 1
    text: @entries[i]
    cursor: cursor
    show_cursor: cursor?
    guide: guide

  advance: (char) ->
    @i += 1
    if @i == @segments.length
      segments = $('.typing-inner>.segments')
      $('.typing-inner').prepend do segments.clone
      segments.css 'top', '150%'
      move('.typing-inner').set('margin-top', '-160px').end ->
        do $('.typing-inner>.segments:first-child').remove
        $('.typing-inner').attr('style', '')
        $('.typing-inner>.segments').css 'top', '50%'
      do @reset
    true

  type_character: (char) ->
    if char != @answers[@i][@entries[@i].length]
      if @guides[@i]
        return false
      @entries[@i] = ''
      @guides[@i] = true
      return true
    @entries[@i] += char
    if @entries[@i] == @answers[@i]
      do @advance
    true


typing = new Typing


Template.typing.data = ->
  Session.get 'typing'


Template.typing.events
  'fauxkeydown': (_, template, e) ->
    if e.which == 32
      if typing.type_character ' '
        do typing.force_redraw
    else if 65 <= e.which < 91
      char = String.fromCharCode e.which
      if not e.shiftKey
        char = do char.toLowerCase
      if typing.type_character char
        do typing.force_redraw
