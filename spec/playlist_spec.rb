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

  describe "Playlist" do
    it "outputs a string to be used in a query" do
      query = ["tempo >= 125.0", "valence >= 0.6", "energy <= 0.4", "genre = 'rock'", "genre = 'pop'"]
      return_string = "tempo >= 125.0 AND valence >= 0.6 AND energy <= 0.4 AND (genre = 'rock' OR genre = 'pop')"
      expect(Playlist.build_query(query)).to eq(return_string)
    end
  end
end
