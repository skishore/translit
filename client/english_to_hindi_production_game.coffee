class EnglishToHindiProductionGame extends Dialog
  DialogManager.register @, 'reverse_translit'
  @template = 'reverse_translit'
  @height: '3.6em'

  constructor: ->
    english = 'bread'
    hindi = 'ब्रेड'
    @answer = @_canonicalize hindi

    n = 8 - @answer.length
    other_choices = (Math.randelt Steps.ALPHABET for i in [0...n])

    @question = english
    @answers = _.shuffle @answer.concat other_choices
    @entry = []
    @_active = true

  _canonicalize: (hindi) ->
    result = []
    last_was_consonant = false
    for char in hindi
      if char == VIRAMA
        last_was_consonant = false
        continue
      consonant = not (char of SIGNS or char of REVERSE_SIGNS)
      if char of REVERSE_SIGNS
        result.push REVERSE_SIGNS[char]
      else
        if consonant and last_was_consonant
          result.push REVERSE_SIGNS['']
        result.push char
      last_was_consonant = consonant
    result

  accepts_input: (char) ->
    ENGLISH[char] or char == '\b' or char == '\r' or char == ';'

  active: -> @_active

  get_data: ->
    data = {question: @question, entry: '', answers: []}

    last_was_consonant = false
    for i in @entry
      char = @answers[i]
      consonant = not (char of SIGNS or char of REVERSE_SIGNS)
      if last_was_consonant
        if consonant
          data.entry += VIRAMA
        else if char of SIGNS
          char = SIGNS[char]
      data.entry += char
      last_was_consonant = consonant

    for answer, i in @answers
      j = @entry.indexOf i
      if j >= 0
        continue
      space = 0.4
      p = i + if i < 4 then 0 else space
      n = @answers.length + space
      data.answers.push
        class: undefined
        left: "#{(Math.floor 100*(2*p + 1)/(2*n))}%"
        text: answer
    data

  on_input: (char) ->
    if char == '\b'
      return do @_on_backspace
    else if char == '\r'
      return do @_on_enter
    @_on_typed_char char

  _on_backspace: ->
    if @entry.length == 0
      return false
    do @entry.pop
    true

  _on_enter: ->

  _on_typed_char: (char) ->
    answer = {a: 0, s: 1, d: 2, f: 3, j: 4, k: 5, l: 6, ';': 7}[char]
    if not answer?
      return false
    assignment = @entry.indexOf answer
    if assignment >= 0
      return false
    @entry.push answer
    true
