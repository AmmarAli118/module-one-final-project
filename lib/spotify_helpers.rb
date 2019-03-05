#Spotify Helpers

  # score
  def score(value)
    # returns a percent value of a float between 0 and 1
    "#{(value * 100).round(2)}%"
  end

  # key_letter
  def key_letter(key_num)
   keys = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
   keys[key_num]
  end

  # song_key
  def song_key(key_mode)
   key_mode == 1 ? "Major" : "Minor"
  end
