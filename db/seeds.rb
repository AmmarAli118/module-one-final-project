# seeds.rb
PlaylistSong.destroy_all
Playlist.destroy_all
Song.destroy_all

# sample data #
#first seed
rock_songs_playlist = get_playlist_by_search("rock")
rap_songs_playlist = get_playlist_by_search("rap")
country_songs_playlist = get_playlist_by_search("outlaw country")

#second seed
classical_songs_playlist = get_playlist_by_search("classical")
pop_songs_playlist = get_playlist_by_search("pop")
jazz_songs_playlist = get_playlist_by_search("jazz")

#third seed
blues_songs_playlist = get_playlist_by_search("blues")
folk_songs_playlist = get_playlist_by_search("folk")
metal_songs_playlist = get_playlist_by_search("metal")
indie_songs_playlist = get_playlist_by_search("indie")
punk_songs_playlist = get_playlist_by_search("punk")
gospel_songs_playlist = get_playlist_by_search("gospel")

# SEED DATA

#  first seed
seed_data(rock_songs_playlist, "rock")
sleep(15)
seed_data(rap_songs_playlist, "rap")
sleep(15)
seed_data(country_songs_playlist, "country")

#second seed
sleep(15)
seed_data(classical_songs_playlist, "classical")
sleep(15)
seed_data(pop_songs_playlist, "pop")
sleep(15)
seed_data(jazz_songs_playlist, "jazz")

#third seed
sleep(15)
seed_data(blues_songs_playlist, "blues")
sleep(15)
seed_data(gospel_songs_playlist, "gospel")
sleep(15)
seed_data(indie_songs_playlist, "indie")
sleep(15)
seed_data(punk_songs_playlist, "punk")
sleep(15)
seed_data(metal_songs_playlist, "metal")
sleep(15)
seed_data(folk_songs_playlist, "folk")
