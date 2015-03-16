Meteor.startup ->
  #DialogManager.instantiate 'HindiToEnglishShortAnswerGame'
  DialogManager.instantiate 'HindiToEnglishMultipleChoiceGame'

  $('body').keydown (e) ->
    e = e or window.event
    char = String.fromCharCode e.which
    if not e.shiftKey
      char = do char.toLowerCase
    DialogManager.on_input char
    do e.preventDefault
    do e.stopPropagation
