class Typing
  constructor: ->
    @segments = do @get_segments
    @answers = ('' for segment in @segments)
    @length = 0
    for segment in @segments
      @length += segment.length
    @current_segment = 0
    do @force_redraw

  force_redraw: ->
    data = {segments: []}
    for segment, i in @segments
      data.segments.push
        text: segment
        answer: @answers[i]
        width: (Math.floor 100*segment.length/@length) + '%'
    Session.set 'typing', data

  get_segments: ->
    (Math.randelt Steps.ALPHABET for _ in [0...Math.randint 3, 6])

  advance: (char) ->
    if @current_segment + 1 < @segments.length
      @current_segment += 1
    do @force_redraw

  type_character: (char) ->
    @answers[@current_segment] += char
    do @force_redraw


typing = new Typing


Template.typing.data = ->
  Session.get 'typing'


Template.typing.events
  'fauxkeydown': (_, template, e) ->
    if e.which == 32
      do typing.advance
    else if 65 <= e.which < 91
      char = String.fromCharCode e.which
      if not e.shiftKey
        char = do char.toLowerCase
      typing.type_character char
