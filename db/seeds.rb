
playlist1 = Playlist.create()

playlistsong1 = PlaylistSong.create()

song1 = Song.create()

playlistsong1.playlist = playlist1
playlistsong1.song = song1

playlistsong1.save 
