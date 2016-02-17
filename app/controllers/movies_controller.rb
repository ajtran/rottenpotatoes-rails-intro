class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.all_ratings
    @checked_ratings = params[:ratings]
    if @checked_ratings.nil?
      @checked_ratings = Hash[@all_ratings.map {|x| [x, 1]}]
    end
    # if @checked_ratings.present?
    session[:ratings] = @checked_ratings
    if session[:ratings].present?
      @checked_ratings = session[:ratings]
    end
    # gotta do something here....
    if @checked_ratings.present?
      @movies = @movies.where(rating: @checked_ratings.keys)
    end
    # saving the sort in session
    @sort_by = params[:sort_by]
    # if @sort_by.present?
    session[:sort_by] = @sort_by
    if session[:sort_by].present?
      @sort_by = session[:sort_by]
    end
    # actual sorting
    if @sort_by == "title"
      @movies = @movies.order(title: :asc)
    elsif @sort_by == "release_date"
      @movies = @movies.order(release_date: :asc)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
