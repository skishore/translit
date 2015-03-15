class @HindiToEnglishTransliterationGame
  @template = 'HindiToEnglishTransliterationGame'
  @height = '140px'

  constructor: (show_guides) ->
    @hindi = ((do Steps.get_segment) for i in [0...Math.randint 3, 6])
    @english = (HindiToEnglish.unsafe hindi for hindi in @hindi)
    @length = _.reduce @hindi, ((sum, hindi) -> sum + hindi.length), 0
    # The user's current entry for each Hindi transliteration task.
    @entries = ('' for i in @hindi)
    @guides = (show_guides for i in @hindi)
    @i = 0

  complete: ->
    @i == @hindi.length

  get_data: ->
    data = {segments: []}
    for hindi, i in @hindi
      data.segments.push
        segment: hindi
        entry: @_encode @_get_entry_data i
        class: if @entries[i] == @english[i] then 'correct' else undefined
        width: (Math.floor 100*hindi.length/@length) + '%'
    data

  _encode: (data) ->
    if data.cursor?
      data.cursor = HindiToEnglish.english_to_display data.cursor
    data.guide = HindiToEnglish.english_to_display data.guide
    data.text = HindiToEnglish.english_to_display data.text
    data

  _get_entry_data: (i) ->
    cursor = undefined
    guide = if @guides[i] then (@english[i].slice @entries[i].length) else ''
    cursor = undefined
    if i == @i
      cursor = guide[0] or ''
      guide = guide.slice 1
    text: @entries[i]
    cursor: cursor
    show_cursor: cursor?
    guide: guide

  on_input: (char) ->
    if char != @english[@i][@entries[@i].length]
      if @guides[@i]
        return false
      @entries[@i] = ''
      @guides[@i] = true
      return true
    @entries[@i] += char
    if @entries[@i] == @english[@i]
      @i += 1
    true


DialogManager.register HindiToEnglishTransliterationGame
