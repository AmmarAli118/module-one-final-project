
rock_playlist = Playlist.create(name: "Rock")
rap_playlist  = Playlist.create(name: "Rap")

i = 0
while i < 10
  song = Song.create(title: "Song #{i}", artist: "Artist #{i}")
  song.album = "Album #{i}"
  song.duration = i
  song.key = i
  song.mode = 0
  song.acousticness = rand()
  song.danceability = rand()
  song.energy = rand()
  song.instrumentalness = rand()
  song.liveness = rand()
  song.speechiness = rand()
  song.valence = rand()
  song.tempo = rand(60..200)
  song.save

  playlist_song = PlaylistSong.create()
  playlist_song.song = song
  if i < 5
    playlist_song.playlist = rock_playlist
  else
    playlist_song.playlist = rap_playlist
  end
  playlist_song.save
  i += 1
end
