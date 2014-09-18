class Typing
  constructor: ->
    segments = do @get_segments
    length = 0
    for segment in segments
      length += segment.length
    @segments = ({
      text: segment
      answer: ''
      width: (Math.floor 100*segment.length/length) + '%'
    } for segment in segments)
    @current_segment = 0

  force_redraw: ->
    Session.set 'typing_trigger', 1 - ((Session.get 'typing_trigger') or 0)

  get_segments: ->
    (Math.randelt Steps.ALPHABET for _ in [0...Math.randint 3, 6])

  advance: (char) ->
    if @current_segment + 1 < @segments.length
      @current_segment += 1
    do @force_redraw

  type_character: (char) ->
    @segments[@current_segment].answer += char
    do @force_redraw


typing = new Typing


Template.typing.helpers
  segments: ->
    Session.get 'typing_trigger'
    typing.segments


Template.typing.events
  'fauxkeydown': (_, template, e) ->
    if e.which == 32
      do typing.advance
    else if 65 <= e.which < 91
      char = String.fromCharCode e.which
      if not e.shiftKey
        char = do char.toLowerCase
      typing.type_character char
