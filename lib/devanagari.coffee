@semantics = @semantics or {}

class semantics.Devanagari
  @VOWELS = ['अ', 'आ', 'इ', 'ई', 'उ', 'ऊ', 'ए', 'ऐ', 'ओ', 'औ']
  @CONSONANT_ROWS = [
    ['क', 'ख', 'ग', 'घ', 'ङ'],
    ['च', 'छ', 'ज', 'झ', 'ञ'],
    ['ट', 'ठ', 'ड', 'ढ', 'ण'],
    ['त', 'थ', 'द', 'ध', 'न'],
    ['प', 'फ', 'ब', 'भ', 'म'],
    ['य', 'र', 'ल', 'व'],
    ['श', 'ष', 'स', 'ह'],
  ]
  @DIGITS = ['०', '१', '२', '३', '४', '५', '६', '७', '८', '९']

  @VIRAMA = '\u094D'

  @CONSONANTS = [].concat.apply [], @CONSONANT_ROWS
  @ALPHABET = @VOWELS.concat @CONSONANTS
  @ALL = @ALPHABET.concat @DIGITS
  assert (typeof @ALL) == 'object', "typeof(ALL) is #{typeof @ALL}"

  @get_segment: ->
    while true
      consonant = Math.randelt @CONSONANTS
      vowel = semantics.SIGNS[Math.randelt @VOWELS]
      if consonant not in ['ङ', 'ञ'] or vowel == ''
        return consonant + vowel
