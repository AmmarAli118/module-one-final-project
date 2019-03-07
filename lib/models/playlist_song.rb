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

  # move_up
  def move_up
    # determines the index the song will move to
    target_index = self.playlist_index - 1
    if target_index > 0
      # move song above down
      PlaylistSong.find_by(playlist_index: target_index).down_index
      self.playlist_index = target_index
    end
    # what should this return?
  end

  # move_down
  def move_down
    target_index = self.playlist_index + 1
    if target_index < self.playlist.length
      # move song below up
      PlaylistSong.find_by(playlist_index: target_index).up_index
      self.playlist_index = target_index
    end
  end

  # reorder_from_index
  def self.reorder_from_index(deleted_index)
    # renumbers all songs in a playlist after a deleted song
    PlaylistSong.where("playlist_index > ?", deleted_index).each do |playlist_song|
      playlist_song.up_index

      # RAW SQL:
      # UPDATE playlist_songs SET playlist_index = playlist_index + 1 WHERE playlist_index >= 2;
      # ALTERNATE CODE:
      # PlaylistSong.where("playlist_index > ?", deleted_index).update_all("playlist_index = playlist_index + 1")
    end
  end
end
