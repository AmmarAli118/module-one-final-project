class CliMenuTagSelection < CliMenu
  attr_accessor :tags

  def initialize(header = "\n", text = "", footer = "",display_size = "versatile")
    @header, @text, @footer, @display_size = header, text, footer, display_size
    @input = ""
    @tags = {"acoustic" => "☐ acoustic", "dancing" => "☐ dancing",
    "instrumental" => "☐ instrumental", "lyrical" => "☐ lyrical",
    "fast" => "☐ fast",  "slow" => "☐ slow",
    "happy" => "☐ happy", "melancholy" => "☐ melancholy",
    "energetic" => "☐ energetic", "chill" => "☐ chill", "live" => "☐ live",
    "country" => "☐ country", "rock" => "☐ rock", "pop" => "☐ pop",
    "classical" => "☐ classical", "rap" => "☐ rap", "jazz" => "☐ jazz"}
  end

  def prompt_user_for_tag_selection
    input_done = false
    array_of_submitted_tags = []

    while (!input_done)
      tag_value_array = []
      i = 1
      self.tags.each do | tag_key, tag_value |
        tag_value_array << "#{tag_value}"
      end
      #maybe put columnize_song_name_array in CliMenu
      self.text = columnize_song_name_array(tag_value_array, false)
      self.display

      self.get_user_input
      input_array = self.input.split
      input_array.each do |word|
        if word == "submit"
          self.tags.each do |key, value|
            if value[0] == "☑"
              array_of_submitted_tags << key
            end
          end
          input_done = true
        elsif (self.tags.keys).include?(word)
          self.tags[word] = "☑ #{word}"
          word == "fast" ? self.tags["slow"] = "☐ slow" : 0
          word == "slow" ? self.tags["fast"] = "☐ fast" : 0
          word == "energetic" ? self.tags["chill"] = "☐ chill" : 0
          word == "chill" ? self.tags["energetic"] = "☐ energetic" : 0
          word == "happy" ? self.tags["melancholy"] = "☐ melancholy" : 0
          word == "melancholy" ? self.tags["happy"] = "☐ happy" : 0
          word == "instrumental" ? self.tags["lyrical"] = "☐ lyrical" : 0
          word == "lyrical" ? self.tags["instrumental"] = "☐ instrumental" : 0
        end
        if word == "exit"
          return "exit"
        end
      end
    end
    array_of_submitted_tags
  end
end
