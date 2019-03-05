# seeds.rb

PlaylistSong.destroy_all
Playlist.destroy_all
Song.destroy_all

# sample data #
rock_songs_playlist = get_playlist_by_search("rock")
rap_songs_playlist = get_playlist_by_search("rap")
country_songs_playlist = get_playlist_by_search("country")

# SEED DATA
seed_data(rock_songs_playlist, "rock")
seed_data(rap _songs_playlist, "rap")
seed_data(country_songs_playlist, "country")
