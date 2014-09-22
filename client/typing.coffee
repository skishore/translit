class Typing
  constructor: ->
    @show_guides = false
    do @reset
    do @force_redraw

  reset: ->
    @segments = ((do Steps.get_segment) for _ in [0...Math.randint 3, 6])
    @answers = (HindiToEnglish.unsafe segment for segment in @segments)
    @entries = ('' for segment in @segments)
    @guides = (@show_guides for segment in @segments)
    @length = 0
    for segment in @segments
      @length += segment.length
    @i = 0

  force_redraw: ->
    Session.set 'typing.current_line', do @get_data

  get_data: ->
    data = {segments: []}
    for segment, i in @segments
      data.segments.push
        segment: segment
        entry: @get_entry_data i
        class: if @entries[i] == @answers[i] then 'correct' else undefined
        width: (Math.floor 100*segment.length/@length) + '%'
    data

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
      Session.set 'typing.last_line', do @get_data
      $('.segments:last-child').css 'top', '150%'
      move('.typing-inner').set('margin-top', '-160px').end ->
        Session.set 'typing.last_line', undefined
        $('.typing-inner').attr 'style', ''
        do $('.segments:first-child').empty
        $('.segments:last-child').css 'top', '50%'
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


Template.typing.last_line = ->
  Session.get 'typing.last_line'

Template.typing.current_line = ->
  Session.get 'typing.current_line'


Template.typing.events
  'fauxkeydown': (_, template, e) ->
    char = String.fromCharCode e.which
    if not e.shiftKey
      char = do char.toLowerCase
    if ENGLISH[char] or char == ' '
      if typing.type_character char
        do typing.force_redraw
