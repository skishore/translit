class @Dialog
  # These static variables should be overridden by subclasses.
  # @name will always be set to the class name by CoffeeScript.
  @height = '0px'

  active: ->
    # Returns true if the dialog is still active.
    assert false, "#{@constructor.name}.active is not implemented!"

  get_data: ->
    # Returns the data needed to instantiate this dialog's Handlebars template.
    assert false, "#{@constructor.name}.get_data is not implemented!"

  on_input: (char) ->
    # Takes a single-character input and return true if the dialog changed.
    assert false, "#{@constructor.name}.on_input is not implemented!"


class @DialogManager
  @_current: null
  @_registry: {}

  @instantiate: (dialog_name) ->
    @_current = new @_registry[dialog_name]
    do @redraw

  @on_input: (char) ->
    if do @_current?.active and @_current.on_input char
      do @redraw

  @redraw: ->
    Session.set 'dialog.current',
      name: @_current.constructor.name
      height: @_current.constructor.height
      data: do @_current.get_data

  @register: (dialog_subclass) ->
    dialog_name = dialog_subclass.name
    assert dialog_name.length > 0, 'Tried to register empty name'
    assert dialog_name not of @_registry, "Duplicate dialog: #{dialog_name}"
    @_registry[dialog_name] = dialog_subclass


# TODO(skishore): Make this function dialog-type independent.
animate = ->
  $('.segments:last-child').css 'top', '150%'
  do typing.reset
  do typing.force_redraw
  move('.typing-inner').set('margin-top', '-160px').end ->
    Session.set 'typing.last_line', undefined
    $('.typing-inner').attr 'style', ''
    do $('.segments:first-child').empty
    $('.segments:last-child').css 'top', '50%'


Template.dialog.helpers {
  last: ->
    data = Session.get 'dialog.last'
    if data?
      Meteor.setTimeout animate, 0
    data
  current: ->
    Session.get 'dialog.current'
}
