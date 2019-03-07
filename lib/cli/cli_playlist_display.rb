class CliPlaylistDisplay include CliStringFormatting
  attr_accessor :playlist, :page_number, :header, :text, :footer, :pages, :input

  def initialize(playlist = nil, page_number = 0)
    @playlist, @page_number = playlist, page_number
    @header = ""
    @text = ""
    @footer = "\n\na)Add Song  b) Remove Song c) Optimize Playlist d) Data e) Reorder f) Previos Page g) Next Page h)Exit\n"
    @pages = []
  end

  def get_song_names
    song_array = []

    self.playlist.order_playlist.each do | song |
      #song_array << "#{song.title} - #{song.artist}"
      song_array << "#{song.short_title} - #{song.artist}"
    end
    song_array
  end

  def get_song_on_current_page(song_number)
    # song_number += page_number * 20
    i = 1
    self.playlist.order_playlist.each do | song |
      if i == song_number
        return song
      end
      i += 1
    end
  end

  def create_pages
    self.pages = split_song_array_into_pages(get_song_names)
  end

  def display
    self.header = "#{playlist.name} - Size: #{self.get_song_names.length}"
    self.text = get_page_string(pages, page_number)
    make_versatile_box(header + "\n" + self.text + footer)
  end

  def get_user_input
    self.input = gets.chomp!
    self.input.downcase!
    self.input
  end

end
