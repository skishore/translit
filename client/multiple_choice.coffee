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
    n = 3
    m = 4
    @permutation = [0...m]
    shuffle @permutation

    hindi = []
    english = []
    for _ in [0...m]
      while true
        new_hindi = do Steps.get_segment
        new_english = HindiToEnglish.unsafe new_hindi
        if (english.indexOf new_english) < 0
          break
      hindi.push new_hindi
      english.push new_english

    @questions = (hindi[i] for i in [0...n])
    @answers = (english[j] for j in @permutation)
    @assignment = []
    do @force_redraw

  force_redraw: ->
    Session.set 'multiple_choice.data', do @get_data

  get_data: ->
    data = {questions: [], answers: []}
    for question, i in @questions
      data.questions.push
        class: if i >= @assignment.length then undefined else 'done'
        left: "#{(Math.floor 100*(2*i + 1)/(2*@questions.length))}%"
        text: question
    labels = 'ASDF'
    for answer, i in @answers
      j = @assignment.indexOf i
      p = if j < 0 then i else j
      n = if j < 0 then @answers.length else @questions.length
      data.answers.push
        class: if j < 0 then undefined else 'done'
        left: "#{(Math.floor 100*(2*p + 1)/(2*n))}%"
        label: labels[i]
        text: answer
    data

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
