module ArtistsHelper

  def display_artist(song)
    song.artist.nil? ? link_to("Add Artist", edit_song_path(song)) : link_to(song.artist_name, artist_path(song.artist))
  end

  def artist_select(song, path)
    nested_context(song, path) ? hidden_field_tag("song[artist_id]", song.artist_id) : select_tag("song[artist_id]", options_from_collection_for_select(Artist.all, :id, :name))
  end

  def display_name(song, path)
    song.artist.name if nested_context(song, path)
  end

  def nested_context(song, path)
    song.artist && path == "nested"
  end
  
end