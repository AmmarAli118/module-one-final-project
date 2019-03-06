#This fixes some of the logger issues -- if you're still having them, enter this in console
ActiveRecord::Base.logger.level= 1

class CLI
  attr_accessor :username

  def run
    exit_flag = false

    welcome_screen

    while !exit_flag
      main_menu
      input = gets.chomp!
      input.downcase!
      case(input)
        when "1", "playlists"
          playlists
        when "2", "songs"
          songs
        when "3", "exit"
          exit_flag = true
      end
    end
  end
  #----------------------------
  #main menu and welcome screen
  #----------------------------
  def main_menu
    make_large_box("Welcome! #{self.username}\n1. Playlists\n2. Songs\n3. Exit")
  end

  def welcome_screen
    make_large_box("\n\n\nPlease enter your name:")

    self.username = gets.chomp!
    if self.username.downcase == "lane"
      black_eyed_peas
    end
  end

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
        make_large_box("Find Playlist\nEnter name of playlist:")
        input = gets.chomp!
        input.downcase!
        #search for playlist
        display_playlist(playlist_search(input))
      when "4", "create playlist"
        create_playlist
    end
  end

  def create_playlist
    make_large_box("Create Playlist\nEnter name for playlist:")
    playlist_name = gets.chomp!
    new_playlist = Playlist.create(name: playlist_name)
    add_song_to_playlist(new_playlist)
  end
  #generate playlist page
  def generate_playlist
    make_large_box("Generate Playlist\nEnter name for playlist:\nEnter number of songs:")

    playlist_name = gets.chomp!
    playlist_size = gets.chomp!

    #Take the user to the tag selection page and retrieve there choices
    array_of_tags = tag_selection
    if array_of_tags.class == String
      return 0
    end
    #generate the new palylist
    new_playlist = Playlist.generate(playlist_name, array_of_tags, playlist_size.to_i)

    input = gets.chomp!
    display_playlist(new_playlist)

  end

  #displays categories to user and gets there selection, some choices are binary and will only allow user to have
  #one selected at a time

  def tag_selection
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
  def display_playlist(playlist)
    if playlist == 0
      return 0
    end
    playlist_song_array = []

    playlist.songs.each do | song |
      playlist_song_array << "#{song.title} - #{song.artist}"
    end

    songs_string = "#{playlist.name}\n"
    #songs_string = print_playlist_songs(playlist_song_array, playlist.name)
    songs_string += columnize_song_name_array(playlist_song_array)
    songs_string += "\n\na)Add Song  b) Remove Song c) Optimize Playlist d) Data e) Reorder\n"
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
    make_large_box(songs_string)
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

  #-------------
  #songs section
  #-------------
  def songs
    make_large_box("Songs\n1. View Top Songs By Tag\n2. Find Song\n3. Back\n")

    input = gets.chomp!
    input.downcase!
    case(input)
      when "1", "view top songs by tag"
        view_top_songs_by_tag
      when "2", "find song"
        find_song
    end
  end

  def view_top_songs_by_tag
    tags = ["acoustic", "dancing", "energetic", "instrumental", "live", "lyrical", "fast", "happy", "melancholy", "slow", "chill"]

    make_large_box("View Top Songs By Tag\nEnter tag to view top 10 songs: \n- acoustic  - dancing  - energetic\n- instrumental  - live   - lyrical\n- fast   - happy   - melancholy\n- slow    - chill\n")

    input = gets.chomp!
    input.downcase!

    tags.each do | tag |
      if input == tag
        top_songs_string = "Top Songs for #{tag}: \n"
        # Song.top.each do | song |
        #   top_songs_string << "#{song}\n"
        # end
        make_large_box(top_songs_string)
      end
    end
  end

  #method for displayling a specific song
  def display_song(song)
    display_song_string = "Song: #{song.title}\t\tArtist: #{song.artist}\t\tAlbum: #{song.album}\n"
    display_song_string += "Genre: #{song.genre}\t\tKey: #{key_letter(song.key)} #{song_key(song.mode)}\n\n"
    song_data = {"acousticness" => song.acousticness, "danceability" => song.danceability,
       "energy" => song.energy, "instrumentalness" => song.instrumentalness, "liveness" => song.liveness,
       "speechiness" => song.speechiness, "valence" => song.valence, "tempo" => song.tempo}
    display_song_string += get_bargraph(song_data, "")
    #make_large_box(display_song_string)
    make_versatile_box(display_song_string)
    gets.chomp!
  end

  #methods for finding a song by search
  def find_song
    make_large_box("Find Song\nEnter name of song:")

    input = gets.chomp!
    input.downcase!
    #search for playlist
    result = song_search(input)
    if result != 0
      display_song(result)
    end
  end
  #creates a formatted string of possible songs based on user input
  def song_search(input)
    songs_string = "Enter number of the song you want: \n"

    i = 1
    possible_songs = Song.where("title LIKE '%#{input}%'")
    if possible_songs.empty?
      playlist_string = "No results found."
      make_large_box(playlist_string)
      gets.chomp!
      return 0
    end
    possible_songs.each do | song |
      songs_string += "#{i}. #{song.title} - #{song.artist}\n"
      i += 1
    end

    make_large_box(songs_string)
    new_input = gets.chomp!
    new_input.downcase!

    possible_songs[(new_input.to_i - 1)]
  end

  #--------------------
  # Artists section
  #--------------------
  #   View all artist - returns a list of artist that begin with a certain letter, is passed a letter (cli displays, the user can choose alphabetical letter and the cli displays all artist that start with that letter)
  #   Find artist - is passed the name of an artist, returns the artist. (cli displays artist)
  def artists
    make_box("Artists\n1. View All Artists\n2. Find Artist\n3. Back")

    input = gets.chomp!
    input.downcase!
    case(input)
      when "1", "view all artists"
        view_all_artists
      when "2", "find artist"
        find_artist
    end
  end

  def view_all_artists
    make_box("view all artist")
  end

  def find_artist
    make_box("find artist")
  end
  #----------------------------
  #Graphs and table makers
  #----------------------------
  def print_table

    table = TTY::Table.new ["Songs In Playlist", "Playlist Data"], [["a1", "a2"], ["b1", "b2"]]
    #make_box(table)
    print table
    test_data = [
      {name: "acoustic", value: 5977, color: :bright_yellow},
      {name: "dancing", value: 3000, color: :bright_green},
      {name: "energetic", value: 2000, color: :bright_magenta},
      {name: "instrumental", value: 3000, color: :bright_cyan},
      {name: "live", value: 6500, color: :bright_black},
      {name: "happy", value: 2500, color: :bright_blue},
      {name: "fast", value: 2500, color: :bright_white}]
    #   {name: "happy", value: 1000, color: :green},
    #   {name: "melancholy", value: 7000, color: :red},
    #   {name: "slow", value: 3000, color: :bright_red},
    #   {name: "chill", value: 4000, color: :cyan}
    # ]
    pie_chart = TTY::Pie.new(data: test_data, radius: 7)
    print pie_chart
  end

  def get_bargraph(data, name)
    system "clear"
    bargraph_string = ""
    bargraph_string += "#{name}\n"
    i = 9
    while i >= 0
      bargraph_string += "#{i} |"
      data.each do | key, value |
        if key != "tempo"
          if (value * 10).round >= i
            (key.length).times do
              bargraph_string += "-"
            end
          else
            (key.length).times do
              bargraph_string += " "
            end
          end
          bargraph_string += " "
        end
      end
      if i == 0
        bargraph_string += " #{data["tempo"].round}"
      end
      bargraph_string += "\n"
      i -= 1
    end
    bargraph_string += "   acousticness danceability energy instrumentalness liveness speechiness valence tempo\n"
    bargraph_string += "---"
    data.each do | key, value |
      if key != "tempo"
        ((key.length - 4) / 2).times do
          bargraph_string += "-"
        end
        bargraph_string += "#{'%.3f' % value}"
        ((key.length - 4) / 2).times do
          bargraph_string += "-"
        end
      else
        (key.length).times do
          bargraph_string += "-"
        end
      end
    end
    bargraph_string
  end
  #-------------------------------
  #Methods for formating output
  #-------------------------------
  def columnize_song_name_array(song_name_array, numbered_items = true, columns = 2)
    formatted_string = ""
    longest_song_name_length = get_length_longest_name_in_array(song_name_array) + 5
    i = 0
    while i < (song_name_array.length)
      if numbered_items
        list_item = "#{i+1}.#{song_name_array[i]}"
      else
        list_item = "#{song_name_array[i]}"
      end
      formatted_string += list_item
      (longest_song_name_length - list_item.length).times do
        formatted_string += " "
      end
      if ((i+1) % columns ) == 0
        formatted_string += "\n"
      end
      i += 1
    end
    formatted_string += "\n---------------------------"
    formatted_string
  end
  #helper method for getting length of longest name in array
  def get_length_longest_name_in_array(song_name_array)
    longest_song_name_length = 0
    song_name_array.each do | song_name |
      if song_name.length > longest_song_name_length
        longest_song_name_length = song_name.length
      end
    end
    longest_song_name_length
  end

  #--------------------------------
  #methods for making display boxes
  #--------------------------------
  def make_large_box(text)
    system "clear"
    box = TTY::Box.frame(width: 100, height:15, border: :thick, title: {top_left: "SPOPTIMIZER"},
      style: {
        fg: :white,
        bg: :black,
        border: {
          fg: :green,
          bg: :black
        }
        }) do
          text
        end
    print box
    box
  end

  def make_versatile_box(text)
    new_line_count = text.count("\n")
    new_line_count += 3
    longest_line = 0
    text.split("\n").each do | line |
      if line.length > longest_line
        longest_line = line.length
      end
    end
    longest_line += 3

    system "clear"
    box = TTY::Box.frame(width: longest_line, height: new_line_count, border: :thick, title: {top_left: "SPOPTIMIZER"},
      style: {
        fg: :white,
        bg: :black,
        border: {
          fg: :green,
          bg: :black
        }
        }) do
          text
        end
    print box
    box
  end

  def black_eyed_peas
    system "clear"
    puts "---------------------------------"
    puts "|    Black-Eyed-Peas Fanclub    |"
    puts "| ----------------------------  |"
    puts "     Welcome! #{self.username}   "
    puts "|                               |"
    puts "| 1. Black-Eyed-Peas            |"
    puts "| 2. Black-Eyed-Peas            |"
    puts "| 3. Black-Eyed-Peas            |"
    puts "| 4. Black-Eyed-Peas            |"
    puts "|                               |"
    puts "---------------------------------"
  end

end
