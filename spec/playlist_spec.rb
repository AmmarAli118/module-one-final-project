# spec/playlist_spec.rb
require "spec_helper"
require "pry"
ActiveRecord::Base.logger.level = 1

describe Playlist do
  let(:playlist) { Playlist.last }
  let(:song) { Song.last }

  before do
    playlist.add_song(song)
  end

  describe "#valid_index" do
    it "returns false if index is outside of the size of the playlist" do
      expect(playlist.valid_index?(1000)).to eq(false)
      expect(playlist.valid_index?(0)).to eq(false)
    end
    it "returns true if index is inside playlist length" do
      expect(playlist.valid_index?(1)).to eq(true)
    end
  end

  describe ".build_query" do
    it "outputs a string to be used in a query" do
      feature_query = ["tempo >= 125.0", "valence >= 0.6", "energy <= 0.4"]
      genre_query = ["genre = 'rock'", "genre = 'pop'"]

      return_string = "tempo >= 125.0 AND valence >= 0.6 AND energy <= 0.4 AND (genre = 'rock' OR genre = 'pop')"
      expect(Playlist.build_query(feature_query, genre_query)).to eq(return_string)
    end
  end

  describe "#change_index" do
    it "changes the song's index to new index" do
      p = Playlist.generate("test 1", ["happy"], 10)
      s1 = p.playlist_songs.find_by(playlist_index: 5)
      s2 = p.playlist_songs.find_by(playlist_index: 2)
      p.change_index(5,2)
      expect(p.playlist_songs.find_by(playlist_index: 2)).to eq(s1)
    end

    it "successfully moves a song above" do
      p = Playlist.generate("test 1", ["happy"], 10)
      s1 = p.playlist_songs.find_by(playlist_index: 5)
      s2 = p.playlist_songs.find_by(playlist_index: 2)
      p.change_index(5,2)
      expect(p.ordered_playlist_songs.map{|song| song.playlist_index}).to eq((1..10).to_a)
    end

    it "successfully moves a song below" do
      p = Playlist.generate("test 1", ["happy"], 10)
      s1 = p.playlist_songs.find_by(playlist_index: 5)
      # s2 = p.playlist_songs.find_by(playlist_index: 2)
      p.change_index(2,5)
      expect(p.ordered_playlist_songs.map{|song| song.playlist_index}).to eq((1..10).to_a)
    end
  end

  describe ".generate_playlist" do
    let(:test_playlist1) { Playlist.generate("test 1", ["happy"], 20) }
    let(:test_playlist2) { Playlist.generate("test 2", ["country", "melancholy", "chill"], 30) }
    let(:test_playlist3) { Playlist.generate("test 3", ["jazz", "country", "slow", "acoustic"], 25) }

    it "generates a playlist" do
      expect(test_playlist1.class).to be(Playlist)
    end

    it "generates a playlist of correct length" do
      expect(test_playlist1.songs.length).to eq(20)
      expect(test_playlist2.songs.length).to eq(30)
      expect(test_playlist3.songs.length).to eq(25)
    end

    it "generates a playlist containing only genres specified" do
      expect(test_playlist2.genres.length).to eq(1)
      expect(test_playlist2.genres).to include("country")
      expect(test_playlist3.genres.length).to eq(2)
      expect(test_playlist3.genres).to include("jazz", "country")
    end
  end

  describe "#optimize" do
    let(:test_playlist_1) { Playlist.generate("test_playlist 1", ["happy"], 20) }
    let(:test_playlist_2) { Playlist.generate("test_playlist 2", ["melancholy", "chill"], 30) }
    let(:test_playlist_3) { Playlist.generate("test_playlist 3", ["rock", "slow", "acoustic"], 25) }
    let(:test_playlist_4) { Playlist.generate("test_playlist 4", ["chill", "live", "happy", "lyrical", "slow", "acoustic"], 25) }
    let(:test_playlist_5) { Playlist.generate("test_playlist 5", ["country", "slow", "acoustic"], 25) }

    it "raises or lowers the average" do
      expect(test_playlist_1.average(:valence)).to be > (test_playlist_1.optimize(:valence, false).average(:valence))
      expect(test_playlist_2.average(:valence)).to be < (test_playlist_2.optimize(:valence, true).average(:valence))
      expect(test_playlist_3.average(:tempo)).to be < (test_playlist_3.optimize(:tempo, true).average(:tempo))
      expect(test_playlist_4.average(:instrumentalness)).to be < (test_playlist_4.optimize(:instrumentalness, true).average(:instrumentalness))
      expect(test_playlist_5.average(:acousticness)).to be > (test_playlist_5.optimize(:acousticness, false).average(:acousticness))
    end

    it "never selects songs of the wrong genre" do
      expect(test_playlist_1.genres).to eq(test_playlist_1.optimize(:acousticness, false).genres)
      expect(test_playlist_2.genres).to eq(test_playlist_2.optimize(:danceability, false).genres)
      expect(test_playlist_3.genres).to eq(test_playlist_3.optimize(:instrumentalness, false).genres)
      expect(test_playlist_4.genres).to eq(test_playlist_4.optimize(:tempo, false).genres)
      expect(test_playlist_5.genres).to eq(test_playlist_5.optimize(:valence, true).optimize(:tempo, true).optimize(:valence, false).genres)
    end

    it "never changes length" do
      expect(test_playlist_1.songs.length).to eq(test_playlist_1.optimize(:danceability, false).songs.length)
      expect(test_playlist_2.songs.length).to eq(test_playlist_2.optimize(:danceability, false).optimize(:valence, false).optimize(:danceability, false).optimize(:tempo, false).songs.length)
      expect(test_playlist_3.songs.length).to eq(test_playlist_3.optimize(:danceability, false).songs.length)
      expect(test_playlist_4.songs.length).to eq(test_playlist_4.optimize(:danceability, false).songs.length)
      expect(test_playlist_5.songs.length).to eq(test_playlist_5.optimize(:danceability, false).songs.length)
    end
  end
end
