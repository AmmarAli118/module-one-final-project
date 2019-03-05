class PlaylistSong < ActiveRecord::Base
  belongs_to :playlist
  belongs_to :song

  # up_index
  def up_index
    self.playlist_index -= 1
    self.save
  end

  # down_index
  def down_index
    self.playlist_index += 1
    self.save
  end

  # reorder_from_index
  def self.reorder_from_index(deleted_index)
    # renumbers all songs in a playlist after a deleted song
    PlaylistSong.where("playlist_index > ?", deleted_index).each do |playlist_song|
      playlist_song.up_index
    end
  end
end
