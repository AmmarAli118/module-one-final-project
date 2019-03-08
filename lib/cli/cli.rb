#This fixes some of the logger issues -- if you're still having them, enter this in console
ActiveRecord::Base.logger.level = 1
require "pry"

class CLI include CliStringFormatting
  attr_accessor :username, :playlist_generate_tag_selection_menu,
                :plain_menu, :playlist_display, :song_display
  def run
    exit_flag = false

    #create menus
    #------------
    welcome_screen = CliMenu.new("\n\n\n", "Please enter your name:", "", "large")
    welcome_screen.display
    self.username = welcome_screen.get_user_input
    if self.username == "lane"
      black_eyed_peas
    end

    self.playlist_generate_tag_selection_menu = CliMenuTagSelection.new("Generate Playlist\nEnter tags for playlist seperated by a space:\nType 'submit' when finished.", "", "", "large")

    self.plain_menu = CliMenu.new("", "", "")

    self.playlist_display = CliPlaylistDisplay.new

    self.song_display = CliSongDisplay.new

    input = ""
    while !exit_flag
      plain_menu.update("Welcome! #{self.username}", "1. Playlists\n2. Songs\n3. Exit", "", "large")
      plain_menu.display
      plain_menu.display
      input = plain_menu.get_user_input
      case (input)
      when "1", "playlists"
        playlists
      when "2", "songs"
        songs
      when "3", "exit"
        exit_flag = true
      end
    end
  end

  def playlists
    plain_menu.update("Playlists", "1. Generate Playlist\n2. View All Playlists\n3. Find Playlist\n4. Create Playlist\n5. Back", "", "large")
    back_flag = false
    while !back_flag
      plain_menu.update("Playlists", "1. Generate Playlist\n2. View All Playlists\n3. Find Playlist\n4. Create Playlist\n5. Back", "", "large")
      plain_menu.display
      input = plain_menu.get_user_input
      case (input)
      when "1", "generate playlist"
        generate_playlist
      when "2", "view all playlists"
        view_all_playlists
      when "3", "find playlist"
        find_playlist
      when "4", "create playlist"
        create_playlist
      when "5", "back"
        back_flag = true
      end
    end
  end

  def songs
    plain_menu.update("Songs", "1. Find Song\n2. Back\n", "", "large")
    back_flag = false
    while !back_flag
      plain_menu.display
      input = plain_menu.get_user_input
      case (input)
      # when "1", "view top songs by tag"
      #   view_top_songs_by_tag
      when "1", "find song"
        find_song
      when "2", "back"
        back_flag = true
      end
    end
  end

  def find_song
    plain_menu.update("Find Song\nEnter name of song:", "", "", "large")
    plain_menu.display
    input = plain_menu.get_user_input
    result = song_search(input)
    if result != 0
      display_song(result)
    end
  end

  def display_song(song)
    song_display.song = song
    song_display.display_new_song
  end

  def generate_playlist
    plain_menu.update("Generate Playlist", "Enter name for playlist:\nEnter number of songs:", "", "large")
    plain_menu.display
    playlist_name = plain_menu.get_user_input
    playlist_size = plain_menu.get_user_input.to_i
    tags = playlist_generate_tag_selection_menu.prompt_user_for_tag_selection
    if tags.class == String
      return 0
    end
    new_playlist = Playlist.generate(playlist_name, tags, playlist_size)
    display_playlist(new_playlist)
  end

  def view_all_playlists
    plain_menu.update("Enter Number To View:", columnize_song_name_array(get_all_playlist_names_array, true, 1), "--------------\na) Delete a Playlist")
    plain_menu.display
    input = plain_menu.get_user_input
    if input == "a" || input == "delete a playlist"
      delete_playlist
    end
    i = 1
    (Playlist.all).each do |playlist|
      if input.to_i == i
        display_playlist(playlist)
        return 0
      end
      i += 1
    end
  end
  def delete_playlist
    plain_menu.update("Enter Number To Delete:", columnize_song_name_array(get_all_playlist_names_array, true, 1), "--------------\n")
    plain_menu.display
    input = plain_menu.get_user_input
    i = 1
    (Playlist.all).each do |playlist|
      if input.to_i == i
        Playlist.delete(playlist)
        break
      end
      i += 1
    end
  end

  def find_playlist
    plain_menu.update("Find Playlist\nEnter name of playlist:", "", "", "large")
    plain_menu.display
    input = plain_menu.get_user_input
    i = 1
    text_string = ""
    possible_playlist = Playlist.where("name LIKE '%#{input}%'")
    if possible_playlist.empty?
      plain_menu.update("No results found.", text_string, "", "large")
      plain_menu.display
      return 0
    end
    possible_playlist.each do |playlist|
      text_string += "#{i}. #{playlist.name}\n"
      i += 1
    end
    plain_menu.update("Enter number of the playlist you want to view:", text_string, "", "large")
    plain_menu.display
    input = plain_menu.get_user_input
    display_playlist(possible_playlist[(input.to_i - 1)])
  end

  def create_playlist
    plain_menu.update("Create Playlist\nEnter name for playlist:", "", "", "large")
    plain_menu.display
    playlist_name = plain_menu.get_user_input
    new_playlist = Playlist.create(name: playlist_name)
    add_song_to_playlist(new_playlist)
    display_playlist(new_playlist)
  end

  def add_song_to_playlist(playlist)
    plain_menu.update("#{playlist.name}\nEnter name of song you want to add:", "", "", "large")
    plain_menu.display
    input = plain_menu.get_user_input

    new_song = song_search(input)
    if new_song != 0
      playlist.add_song(new_song)
    end
    #display_playlist(playlist)
  end

  def remove_song_from_playlist
    plain_menu.update("#{playlist_display.playlist.name}\n", columnize_song_name_array(playlist_display.get_song_names), "\nEnter number of song you want to remove: \n")
    plain_menu.display
    input = plain_menu.get_user_input.to_i

    i = 1
    song_to_delete = nil
    playlist_display.playlist.songs.each do |song|
      # if "#{(song.title).downcase!} - #{(song.artist).downcase!}" == input.downcase!
      #   song_to_delete = song
      # end
      if i == input
        song_to_delete = song
      end
      i += 1
    end
    if song_to_delete != nil
      playlist_display.playlist.delete_song(song_to_delete)
    end
    i += 1
  end

  def optimize_playlist
    plain_menu.clear
    plain_menu.header = "Optimize Playlist: #{playlist_display.playlist.name}"
    plain_menu.text = "Enter a feature to optimize: \n-acousticness -danceability -energy\n-instrumentalness -liveness \n-valence   -tempo\n"
    plain_menu.display_size = "large"
    plain_menu.display
    input = plain_menu.get_user_input
    feature = input.to_sym

    plain_menu.header = "Optimize Playlist\nFeature to optimize: #{feature}\n"
    plain_menu.text = "Would you like to increase or decrease the amount of #{feature} in the playlist? \nEnter 'increase' or 'decrease':\n"
    plain_menu.display
    input = plain_menu.get_user_input
    increment = false
    if input == "increase"
      increment = true
    elsif input == "decrease"
      increment = false
    else
      return 0
    end

    plain_menu.header = "Optimize Playlist\nFeature to #{input}: #{feature}\n"
    plain_menu.text = "What percent of your playlist are you willing to change?\nEnter number from 0-100: \n"
    plain_menu.display
    input = plain_menu.get_user_input.to_f

    if [0..100].include?(input.to_i)
      return 0
    end

    playlist_display.playlist.optimize(feature, increment, (input / 100))
  end

  def display_data(playlist)
    plain_menu.clear
    plain_menu.text = get_bargraph(playlist.get_averages, playlist.name)
    plain_menu.display
    plain_menu.get_user_input
  end

  def display_playlist(playlist)
    playlist_display.playlist = playlist
    playlist_display.create_pages
    exit_flag = false
    while !exit_flag
      playlist_display.display
      input = playlist_display.get_user_input
      case (input)
      when "a", "add song"
        add_song_to_playlist(playlist)
        playlist_display.create_pages
      when "b", "remove song"
        remove_song_from_playlist
        playlist_display.create_pages
      when "c", "optimize playlist"
        optimize_playlist
        playlist_display.create_pages
      when "d", "data"
        display_data(playlist)
      when "e", "reorder"
        reorder_playlist(playlist)
        playlist_display.create_pages
      when "f", "previous page"
        if playlist_display.page_number > 0
          playlist_display.page_number -= 1
        end
      when "g", "next page"
        if playlist_display.page_number < playlist_display.pages.length - 1
          playlist_display.page_number += 1
        end
      when "h", "exit"
        exit_flag = true
        #return 0
      end
      range_start = (playlist_display.page_number * 20) + 1
      range_end = range_start + 20
      if (range_start..range_end).include?(input.to_i)
        display_song(playlist_display.get_song_on_current_page(input.to_i))
      end
    end
  end

  def reorder_playlist(playlist)
    plain_menu.clear
    plain_menu.header = "Enter the number of the playlist you want to move:\nEnter the index you want to move it to:"
    plain_menu.text = columnize_song_name_array(playlist_display.get_song_names)
    plain_menu.display

    index_playlist_to_move = (plain_menu.get_user_input).to_i
    index_to_move_to = (plain_menu.get_user_input).to_i

    playlist.change_index(index_playlist_to_move, index_to_move_to)
  end

  def song_search(input)
    i = 1
    text_string = ""
    possible_songs = Song.where("title LIKE '%#{input}%'")
    if possible_songs.empty?
      plain_menu.update("No results found.", "", "", "large")
      plain_menu.display
      return 0
    end
    possible_songs.each do |song|
      text_string += "#{i}. #{song.title} - #{song.artist}\n"
      i += 1
    end
    plain_menu.update("Song Search\nEnter number of the song you want: ", text_string, "", "large")
    plain_menu.display
    input = plain_menu.get_user_input

    possible_songs[(input.to_i - 1)]
  end

  def black_eyed_peas
    black_eyed_peas_menu = CliMenu.new("Welcome to Black Eyed Peas fanclub! #{self.username}", "", "", "large")
    black_eyed_peas_menu.display
    black_eyed_peas_menu.get_user_input
  end
end
