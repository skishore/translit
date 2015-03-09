shuffle = (array) ->
  i = array.length
  while i > 0
    j = Math.floor (do Math.random)*i
    i -= 1
    if i != j
      [array[i], array[j]] = [array[j], array[i]]


class MultipleChoice
  constructor: ->
    do @reset
    do @force_redraw

  reset: ->
    @questions = ((do Steps.get_segment) for _ in [0...4])
    @permutation = [0...@questions.length]
    shuffle @permutation
    @answers = (HindiToEnglish.unsafe @questions[j] for j, _ in @permutation)
    @assignment = []
    do @force_redraw

  force_redraw: ->
    Session.set 'multiple_choice.data', do @get_data

  get_data: ->
    data = {questions: [], answers: []}
    for question, i in @questions
      data.questions.push
        left: "#{(Math.floor 100*(2*i + 1)/(2*@questions.length))}%"
        text: question
    labels = 'ASDF'
    for answer, i in @answers
      j = @assignment.indexOf i
      p = if j < 0 then i else j
      data.answers.push
        left: "#{(Math.floor 100*(2*p + 1)/(2*@questions.length))}%"
        top: if j < 0 then '2em' else '0em'
        text: "#{labels[i]}: #{answer}"
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

  complete: ->
    false

  type_character: (char) ->
    if char == '\b'
      if @assignment.length > 0
        do @assignment.pop
        return true
      return false
    index = {a: 0, s: 1, d: 2, f: 3}[char]
    if not index?
      return false
    assignment = @assignment.indexOf index
    if assignment >= 0
      return false
    @assignment.push index
    true


multiple_choice = new MultipleChoice


Template.multiple_choice.helpers data: -> Session.get 'multiple_choice.data'


Template.multiple_choice.events
  'fauxkeydown': (_, template, e) ->
    char = String.fromCharCode e.which
    if not e.shiftKey
      char = do char.toLowerCase
    if ENGLISH[char] or char == ' ' or char == '\b'
      if ((not do multiple_choice.complete) and
          multiple_choice.type_character char)
        do multiple_choice.force_redraw
    do e.preventDefault
    do e.stopPropagation
