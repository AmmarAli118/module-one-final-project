# seeds.rb
require_rel "../config/environment.rb"
# authenticate
def authenticate
  # Authenticate RSpotify Wrapper
  RSpotify.authenticate(API_KEY, API_SECRET)
end

# get_playlist_by_search
def get_playlist_by_search(search_term)
  RSpotify::Playlist.search(search_term, limit: 1)
end

# seed_data
def seed_data(playlist, genre)
  playlist.tracks.each do |track|
    # create instance variables for legibility
    name = track.name
    artist = track.artists.first.name
    album = track.album.name
    features = track.audio_features

    # creates new song instance with api data
    Song.find_or_create_by(
      title: name,
      artist: artist,
      album: album,
      duration: features.duration,
      key: features.key,
      mode: features.mode,
      acousticness: acousticness,
      danceability: danceability,
      energy: energy,
      instrumentalness: instrumentalness,
      liveness: liveness,
      speechiness: speechiness,
      valence: valence,
      tempo: tempo,
      genre: genre,
    )
  end
end

authenticate
# sample data #
rock_songs_playlist = get_playlist_by_search("rock").first

# SEED DATA

seed_data(rock_songs_playlist, "rock")
