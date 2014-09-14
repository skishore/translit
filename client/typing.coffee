compute_widths = (segments) ->
  total = 0
  for segment in segments
    total += segment.text.length
  for segment in segments
    segment.width = (Math.floor 100*segment.text.length/total) + '%'
  segments


Template.typing.helpers
  segments: ->
    result = []
    for segment in ['a', 's', 'd', 'f']
      result.push {text: segment, answer: ''}
    compute_widths result
