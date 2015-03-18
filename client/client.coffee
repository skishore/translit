Meteor.startup ->
  do DialogManager.instantiate_random_dialog

  $('body').keydown (e) ->
    e = e or window.event
    char = if e.which == 186 then ';' else String.fromCharCode e.which
    if not e.shiftKey
      char = do char.toLowerCase
    DialogManager.on_input char
    do e.preventDefault
    do e.stopPropagation
