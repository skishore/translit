Meteor.startup ->
  $('body').keydown (e) ->
    $('.multiple-choice').trigger 'fauxkeydown', (e or window.event)
