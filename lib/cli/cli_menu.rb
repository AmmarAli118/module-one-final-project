class CliMenu include CliStringFormatting
  attr_accessor :header, :text, :footer, :display_size, :input

  def initialize(header = "", text = "", footer = "", display_size = "versatile")
    @header, @text, @footer, @display_size = header, text, footer, display_size
    @input = ""
  end

  def display
    if self.display_size == "versatile"
      self.make_versatile_box(header + "\n" + self.text + footer)
    elsif self.display_size == "large"
      self.make_large_box(header + "\n" + self.text + footer)
    end
  end

  def clear
    self.header = ""
    self.text = ""
    self.footer = ""
    self.display_size = "versatile"
  end

  def update(header = "", text = "", footer = "", display_size = "versatile")
    @header, @text, @footer, @display_size = header, text, footer, display_size
    @input = ""
  end

  def get_user_input
    self.input = gets.chomp!
    self.input.downcase!
    self.input
  end
  #maybe put columnize_song_name_array in CliMenu


end
