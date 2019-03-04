class Song < ActiveRecord::Base
  has_many :playlist_songs
  has_many :playlists, through: :playlist_songs

  def display(include_title = true)
    #puts the song details
    self.attributes.map do |name, value|
      unless (!include_title && name == :title)
        puts "     #{name}: #{value}"
      end
    end
    puts "--------------------------------------------"
  end
end
