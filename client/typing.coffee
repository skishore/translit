get_segments = ->
  result = []
  for _ in [0...Math.randint 3, 6]
    result.push Math.randelt Steps.ALPHABET
  result

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
    for segment in do get_segments
      result.push {text: segment, answer: ''}
    compute_widths result
