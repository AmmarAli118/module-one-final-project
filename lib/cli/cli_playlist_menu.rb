#class for instance of playlist menu to display in cli

  #--------------------------
  # Playlist menu and options
  #--------------------------

  def playlists
    make_large_box("Playlists\n1. Generate Playlist\n2. View All Playlists\n3. Find Playlist\n4. Create Playlist\n5. Back")

    input = gets.chomp!
    input.downcase!
    case (input)
      when "1", "generate playlist"
        generate_playlist
      when "2", "view all playlists"
        view_all_playlists
      when "3", "find playlist"
        find_playlist
      when "4", "create playlist"
        create_playlist
    end
  end

  #generate playlist page
  def generate_playlist
    make_large_box("Generate Playlist\nEnter name for playlist:\nEnter number of songs:")

    playlist_name = gets.chomp!
    playlist_size = gets.chomp!

    #Take the user to the tag selection page and retrieve there choices
    array_of_tags = prompt_user_for_tag_selection
    if array_of_tags.class == String
      return 0
    end
    #generate the new palylist
    new_playlist = Playlist.generate(playlist_name, array_of_tags, playlist_size.to_i)
    display_playlist(new_playlist)

  end

  #displays categories to user and gets there selection, some choices are binary and will only allow user to have
  #one selected at a time

  def prompt_user_for_tag_selection
    input = ""
    input_done = false

    tags = {"acoustic" => "☐ acoustic", "dancing" => "☐ dancing",
    "live" => "☐ live", "lyrical" => "☐ lyrical",
    "fast" => "☐ fast",  "slow" => "☐ slow",
    "happy" => "☐ happy", "melancholy" => "☐ melancholy",
    "energetic" => "☐ energetic", "chill" => "☐ chill",  "instrumental" => "☐ instrumental",
    "country" => "☐ country", "rock" => "☐ rock", "pop" => "☐ pop",
    "classical" => "☐ classical", "rap" => "☐ rap", "jazz" => "☐ jazz"}

    array_of_tags = []

    while (!input_done)
      tag_string = "Generate Playlist\nEnter tags for playlist seperated by a space:\nType 'submit' when finished.\n"
      tag_value_array = []
      i = 1
      tags.each do | tag_key, tag_value |
        tag_value_array << "#{tag_value}"
      end
      tag_string += columnize_song_name_array(tag_value_array, false)
      make_versatile_box(tag_string)

      input = gets.chomp!
      input.downcase!
      input_array = input.split
      input_array.each do |word|
        if word == "submit"
          tags.each do |key, value|
            if value[0] == "☑"
              array_of_tags << key
            end
          end
          #make_large_box(array_of_tags.uniq.to_s)
          input_done = true
        elsif (tags.keys).include?(word)
          tags[word] = "☑ #{word}"
          word == "fast" ? tags["slow"] = "☐ slow" : 0
          word == "slow" ? tags["fast"] = "☐ fast" : 0
          word == "energetic" ? tags["chill"] = "☐ chill" : 0
          word == "chill" ? tags["energetic"] = "☐ energetic" : 0
          word == "happy" ? tags["melancholy"] = "☐ melancholy" : 0
          word == "melancholy" ? tags["happy"] = "☐ happy" : 0
        end
        if word == "exit"
          return "exit"
        end
      end
    end
    array_of_tags
  end

  def find_playlist
    make_large_box("Find Playlist\nEnter name of playlist:")
    input = gets.chomp!
    input.downcase!
    #search for playlist
    display_playlist(playlist_search(input))
  end

  def create_playlist
    make_large_box("Create Playlist\nEnter name for playlist:")
    playlist_name = gets.chomp!
    new_playlist = Playlist.create(name: playlist_name)
    add_song_to_playlist(new_playlist)
  end

  #helper method that returns an array of all playlist names
  def get_all_playlist_names_array
    all_playlist_names_array = []
    Playlist.all.each do | playlist |
      all_playlist_names_array << playlist.name
    end
    all_playlist_names_array
  end

  #deletes a playlist permanently
  def delete_playlist
    all_playlist_string = "Enter Number To Delete: \n"
    all_playlist_string += columnize_song_name_array(get_all_playlist_names_array, true, 1)
    all_playlist_string += "--------------\n"
    make_large_box(all_playlist_string)
    input = gets.chomp!

    i = 1
    (Playlist.all).each do | playlist |
      if input.to_i == i
        Playlist.delete(playlist)
        break
      end
      i += 1
    end
  end

  #Displays a list of all playlist in the database and allows you to delete one
  def view_all_playlists
    all_playlist_string = "Enter Number To View: \n"
    all_playlist_string += columnize_song_name_array(get_all_playlist_names_array, true, 1)
    all_playlist_string += "--------------\n"
    all_playlist_string += "a) Delete a Playlist"

    make_large_box(all_playlist_string)

    #read and evaluate user input if it is 'a' or 'delete a playlist' take the user
    #to the page for deleting a plalyist
    input = gets.chomp!
    if input == "a" || input == "delete a playlist"
      delete_playlist
    end

    i = 1
    (Playlist.all).each do | playlist |
      if input.to_i == i
        display_playlist(playlist)
        break
      end
      i += 1
    end
  end

  #Search methods for playlist
  ############################
  #Page to conduct search and display possible results to the user
  def playlist_search(input)
    playlist_string = "Enter number of the playlist you want to view: \n"

    i = 1
    possible_playlist = Playlist.where("name LIKE '%#{input}%'")
    if possible_playlist.empty?
      playlist_string = "No results found."
      make_large_box(playlist_string)
      gets.chomp!
      return 0
    end
    possible_playlist.each do | playlist |
      playlist_string += "#{i}. #{playlist.name}\n"
      i += 1
    end

    make_large_box(playlist_string)
    new_input = gets.chomp!
    new_input.downcase!

    possible_playlist[(new_input.to_i - 1)]
  end

  #display methods for an individual playlist
  ######################################
  #Page for displating a singular playlist
  def display_playlist(playlist, page_number = 0)
    #used for exiting display playlist in event of error or user exiting
    if playlist == 0
      return 0
    end
    playlist_song_array = []

    playlist.songs.each do | song |
      playlist_song_array << "#{song.title} - #{song.artist}"
    end

    songs_string = "#{playlist.name} - Size: #{playlist_song_array.length}\n"
    #songs_string = print_playlist_songs(playlist_song_array, playlist.name)
    #songs_string += columnize_song_name_array(playlist_song_array)

    #pages is an array of string arrays
    pages = split_song_array_into_pages(playlist_song_array)
    songs_string += get_page_string(pages, page_number)
    songs_string += "\n\na)Add Song  b) Remove Song c) Optimize Playlist d) Data e) Reorder f) Previos Page g) Next Page\n"
    make_versatile_box(songs_string)

    input = gets.chomp!
    input.downcase!
    if input == "a" || input == "add song"
      add_song_to_playlist(playlist)
    elsif input == "b" || input == "remove song"
      remove_song_from_playlist(playlist)
    elsif input == "c" || input == "optimize playlist"
      optimize_playlist(playlist)
    elsif input == "d" || input == "data"
      display_data(playlist)
    elsif input == "e" || input == "reorder"
      reorder_playlist(playlist)
    elsif input == "f" || input == "previos page"
      if page_number > 0
        display_playlist(playlist, page_number-1)
      end
    elsif input == "g" || input == "next page"
      if page_number < (pages.length - 1)
        display_playlist(playlist, page_number+1)
      end
    end
  end

  #method for displaying data to the user, bargraph and pie charts
  def display_data(playlist)
    make_versatile_box(get_bargraph(playlist.get_averages, playlist.name))
    gets.chomp!
    display_playlist(playlist)
  end

  #method for reordering the playlist
  def reorder_playlist(playlist)

  end

  #Displays page for adding a song to a playlist
  def add_song_to_playlist(playlist)
    playlist_song_array = get_array_of_playlist_song_names(playlist)

    songs_string = "#{playlist.name}\n"
    songs_string += columnize_song_name_array(playlist_song_array)
    songs_string += "\nEnter name of song you want to add: \n"
    make_large_box(songs_string)
    input = gets.chomp!
    input.downcase!

    new_song = song_search(input)
    playlist.add_song(new_song)
    display_playlist(playlist)
  end
  #helper method for returning an array of song names
  def get_array_of_playlist_song_names(playlist)
    playlist_song_array = []
    (playlist.songs).each do | song |
      playlist_song_array << "#{song.title}"
    end
    playlist_song_array
  end

  #method to remove a song from playlist, displays page to user and deletes song
  def remove_song_from_playlist(playlist)
    playlist_song_array = get_array_of_playlist_song_names(playlist)

    songs_string = "#{playlist.name}\n"
    songs_string += columnize_song_name_array(playlist_song_array)
    songs_string += "\nEnter name of song you want to remove: \n"
    make_versatile_box(songs_string)
    input = gets.chomp!
    input.downcase!

    song_to_delete = nil
    playlist.songs.each do | song |
      if (song.title).downcase! == input
        song_to_delete = song
      end
    end
    if song_to_delete != nil
      playlist.delete_song(song_to_delete)
    end
    display_playlist(playlist)
  end

  def optimize_playlist(playlist)
    optimize_prompt = "Optimize Playlist: #{playlist.name}\nEnter a feature to optimize: \n-acousticness -danceability -energy\n-instrumentalness -liveness -speechiness\n-valence   -tempo\n"
    make_versatile_box(optimize_prompt)
    input = gets.chomp!
    input.downcase!
    feature = input

    optimize_prompt = "Optimize Playlist\nFeature to optimize: #{feature}\n"
    optimize_prompt += "Would you like to increase or decrease the amount of #{feature} in the playlist? \nEnter 'increase' or 'decrease':\n"
    make_versatile_box(optimize_prompt)
    input = gets.chomp!
    input.downcase!

    increment = false
    if input == "increase"
      increment = true
    elsif input == "decrease"
      increment = false
    else
      return 0
    end

    optimize_prompt = "Optimize Playlist\nFeature to #{input}: #{feature}\n"
    optimize_prompt += "What percent of your playlist are you willing to change?\nEnter number from 0-100: \n"
    make_versatile_box(optimize_prompt)
    input = gets.chomp!
    input.downcase!

    if (0..100).include?(input.to_f)
      return 0
    end

    playlist.optimize(feature, (input.to_f / 100), increment)
    display_playlist(playlist)
  end
