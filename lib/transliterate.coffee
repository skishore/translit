ENGLISH = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
ACCEPT = {}
ACCEPT[character] = true for character in ENGLISH

VIRAMA = '\u094D'


class @EnglishToHindi
  constructor: (english) ->
    @error = ''
    @hindi = ''
    @state = ''
    @last_was_consonant = false
    @process english

  process: (english) ->
    @advance_state character, i for character, i in english
    if english.length
      do @pop_state

  advance_state: (character, i) ->
    if @error.length
      return
    if not ACCEPT[character]
      if character == ' '
        do @pop_state
      else
        @error = "Unexpected character at #{i}: #{character}"
        return
    next_state = @state + character
    if @is_valid_prefix next_state
      @state = next_state
    else if @state == ''
      @error = "Unexpected character at #{i}: #{character}"
      return
    else
      do @pop_state
      @advance_state character, i

  is_valid_prefix: (state) ->
    state == 'z' or state of TRANSLITERATIONS

  pop_state: ->
    assert @state.length > 0, 'Called pop_state without state!'
    hindi = TRANSLITERATIONS[@state]
    assert hindi?, "Unexpected state: #{@state}"
    is_consonant = hindi not of SIGNS
    if @last_was_consonant
      if is_consonant
        @hindi += VIRAMA
      else
        hindi = SIGNS[hindi]
    @hindi += hindi
    @state = ''
    @last_was_consonant = is_consonant
