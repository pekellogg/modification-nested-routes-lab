class SongsController < ApplicationController
  def index
    # artist_id defined in params
    if artist_context
      # artist exists
      if @artist = Artist.find_by(id: artist_context)
        @songs = @artist.songs
      # artist doesn't exist
      else
        redirect_to(artists_path, alert: "Artist not found")
      end
    # songs without artist context
    else
      @songs = Song.all
    end
  end

  def show
    if artist_context
      if @artist = Artist.find_by(id: artist_context)
        if @song = @artist.songs.find_by(id: params[:id])
          render(:show)
        else
          redirect_to(artist_songs_path(@artist), alert: "Song not found")
        end
      end
    else
      @song = Song.find(params[:id])
    end
  end

  def new
    if artist_context && !Artist.exists?(params[:artist_id])
      redirect_to(artists_path, alert: "Artist not found.")
    else
      @song = Song.new(artist_id: params[:artist_id])
    end
  end

  def create
    @song = Song.new(song_params)
    if @song.save
      redirect_to(@song)
    else
      render(:new)
    end
  end

  def edit
    if artist_context
      artist = Artist.find_by(id: params[:artist_id])
      if artist.nil?
        redirect_to artists_path, alert: "Artist not found"
      else
        @song = artist.songs.find_by(id: params[:id])
        redirect_to(artist_songs_path(artist), alert: "Song not found") if @song.nil?
      end
    else
      @song = Song.find(params[:id])
    end
  end

  def update
    @song = Song.find(params[:id])
    @song.update(song_params)
    if @song.save
      redirect_to(@song)
    else
      render(:edit) 
    end
  end

  def destroy
    @song = Song.find(params[:id])
    @song.destroy
    flash[:notice] = "Song deleted."
    redirect_to(songs_path)
  end

  private

  def song_params
    params.require(:song).permit(:title, :artist_name, :artist_id)
  end

  def artist_context
    params[:artist_id] ? params[:artist_id] : false
  end

end

