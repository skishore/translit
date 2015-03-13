Meteor.startup ->
  $('body').keydown (e) ->
    $('.typing').trigger 'fauxkeydown', (e or window.event)
