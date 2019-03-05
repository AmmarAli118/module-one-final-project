class PlaylistSong < ActiveRecord::Base
  belongs_to :playlist
  belongs_to :song

  # new_index
  def change_index(new_index)

  end
end
