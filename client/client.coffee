Meteor.startup ->
  DialogManager.instantiate 'HindiToEnglishMultipleChoiceGame'
  #DialogManager.instantiate 'HindiToEnglishShortAnswerGame'

  $('body').keydown (e) ->
    e = e or window.event
    char = String.fromCharCode e.which
    if not e.shiftKey
      char = do char.toLowerCase
    DialogManager.on_input char
    do e.preventDefault
    do e.stopPropagation
