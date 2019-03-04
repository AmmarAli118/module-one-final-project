#Key Stuffs
# module SpotifyHelpers
# require 'pry'
# require 'rspotify'

RSpotify.authenticate(API_KEY, API_SECRET)
  def key_letter(key_num)
   keys = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
   keys[key_num]
  end

  def song_key(key_mode)
   key_mode == 1 ? "Major" : "Minor"
  end

  def print_songs_with_key(song_array)
    song_array.each do | track |
      print "#{track.name} --- "
      track.artists.each{|artist| print artist.name}
      print "#{print_key(track.audio_features.key, track.audio_features.mode)}"
      puts ""
    end
    " "
  end

  def print_songs(array)
    array.each do | track |
      print "#{track.name} --- "
      track.artists.each{|artist| print artist.name}
      #print " --- Key: #{track.audio_features.key} , Energy: #{track.audio_features.energy}, Danceability: #{track.audio_features.danceability}"
      puts ""
    end
    " "
  end

  def sort_track_array_by_popular(track_array)
    track_array.sort_by do | track |
      track.popularity
    end
  end

  def get_tracks_from_playlist(playlist)
    #returns an array of tracks
    playlist.tracks.collect do | track |
      track
    end
  end

  def get_sample_array(term)
    #searchs for first 5 playlist and puts them in a song array
    sample = []
    playlists = RSpotify::Playlist.search(term, limit: 5)
    playlists.each do | playlist |
      sample += get_tracks_from_playlist(playlist)
    end
    sample.uniq
  end

  binding.pry
  0
