#Key Stuffs
def key_letter(key_num)
  letters = ["C", "C#", "D", "E", "F", "F#", "G", "G#", "A", "A#", "B", "B#"]
  letters[key_num]
end

def major_or_minor(key_mode)
  if key_mode == 1
    "Major"
  else
    "Minor"
  end
end

def print_key(key_num, key_mode)
  print "--- Key:  #{key_letter(key_num)} #{major_or_minor(key_mode)}"
end

def print_songs_with_key(song_array)
  song_array.each do | track |
    print "#{track.name} --- "
    track.artists.each{|art| print art.name}
    print "#{print_key(track.audio_features.key, track.audio_features.mode)}"
    puts ""
  end
  " "
end

#

def print_songs(array)
  array.each do | track |
    print "#{track.name} --- "
    track.artists.each{|art| print art.name}
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

def grab_tracks_from_playlist(playlist)
  #returns an array of tracks
  playlist.tracks.collect do | track |
    track
  end
end

def grab_sample_array(term)
  #searchs for first 5 playlist and puts them in a song array 
  sample = []
  playlists = RSpotify::Playlist.search(term, limit: 5)
  playlists.each do | playlist |
    sample += grab_tracks_from_playlist(playlist)
  end
  sample.uniq
end
