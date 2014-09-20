class Typing
  constructor: ->
    do @reset
    do @force_redraw

  reset: ->
    @segments = do @get_segments
    @entries = ('' for segment in @segments)
    @answers = (REVERSE_TRANSLITERATIONS[segment] for segment in @segments)
    @length = 0
    for segment in @segments
      @length += segment.length
    @current_segment = 0

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
    text: @entries[i]
    cursor: i == @current_segment

  advance: (char) ->
    if @current_segment + 1 < @segments.length
      @current_segment += 1
    else
      do @reset

  type_character: (char) ->
    @entries[@current_segment] += char
    if @entries[@current_segment] == @answers[@current_segment]
      do @advance


typing = new Typing


Template.typing.data = ->
  Session.get 'typing'


Template.typing.events
  'fauxkeydown': (_, template, e) ->
    if e.which == 32
      do typing.advance
      do typing.force_redraw
    else if 65 <= e.which < 91
      char = String.fromCharCode e.which
      if not e.shiftKey
        char = do char.toLowerCase
      typing.type_character char
      do typing.force_redraw
