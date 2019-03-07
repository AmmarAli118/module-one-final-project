# spec/playlist_spec.rb
require 'spec_helper'

describe Playlist do
  let(:playlist) {Playlist.last}
  let(:song) {Song.last}

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


  describe ".generate_playlist" do
    let(:test_playlist1)  {Playlist.generate("test 1", ["happy"], 20)}
    let(:test_playlist2) {Playlist.generate("test 2", ["country", "melancholy", "chill"], 30)}
    let(:test_playlist3) {Playlist.generate("test 3", ["jazz", "country", "slow", "acoustic"], 25)}

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
end
