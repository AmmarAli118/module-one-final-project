class CliSongDisplay include CliStringFormatting
  attr_accessor :song, :header, :text, :footer

  def initialize(song = nil)
    @song = song
    @header = ""
    @text = ""
    @footer = ""
  end

  def display_new_song
    self.header = "Song: #{song.title.truncate(35)}\t\tArtist: #{song.artist}\t\tAlbum: #{song.album.truncate(30)}\n"
    self.header += "Genre: #{song.genre.upcase}\t\tKey: #{key_letter(song.key)} #{song_key(song.mode)}\n\n"
    song_data = {"acousticness" => song.acousticness, "danceability" => song.danceability,
       "energy" => song.energy, "instrumentalness" => song.instrumentalness, "liveness" => song.liveness,
       "speechiness" => song.speechiness, "valence" => song.valence, "tempo" => song.tempo}
    self.text = get_bargraph(song_data, "")
    self.display
  end

  def display
    make_versatile_box(header + "\n" + self.text + footer)
    gets.chomp!
  end

  def get_user_input
    self.input = gets.chomp!
    self.input.downcase!
    self.input
  end
end
