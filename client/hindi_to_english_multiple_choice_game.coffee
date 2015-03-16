class HindiToEnglishMultipleChoiceGame extends Dialog
  DialogManager.register @
  @height: '160px'

  constructor: ->
    n = 3
    m = 4
    @permutation = _.shuffle [0...m]

    hindi = []
    english = []
    for i in [0...m]
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

  accepts_input: (char) ->
    ENGLISH[char] or char == ' ' or char == '\b'

  active: -> true

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
        text: HindiToEnglish.english_to_display answer
    data

  on_input: (char) ->
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