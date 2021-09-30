class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
   checkBoxMemory
   
  end
  
  
  def sort
    @sort = params[:sort] 
    @movies = Movie.order @sort
  end
  
  
  # def checkBox
  #   @all_ratings = ['G', 'PG', 'PG-13', 'R']
  #   @lists = {}
    
   
  #   @ratingSave = params[:ratings] || session[:ratings]
  #   if @ratingSave == nil
  #     session[:ratings] = {}
  #     @all_ratings.each do |rating|
  #       session[:ratings][rating] = 1
  #     end
  #     @ratingSave = session[:ratings]
  #   end
    
    
    
  #   @all_ratings.each do |rating|
  #     if !@ratingSave.nil? && @ratingSave.keys.include?(rating)
  #       @lists[rating] = 1
  #     end
  #   end
  #   session[:ratings] = @ratingSave
    
    
  #   if @ratingSave
  #     @movies = Movie.where(:rating => @ratingSave.keys).order @sort
  #   end
  # end
  
  def checkBoxMemory
    @all_ratings = ['G', 'PG', 'PG-13', 'R']
    @lists = {}
    
   
    @ratingSave = params[:ratings] || session[:ratings]
    if @ratingSave == nil
      session[:ratings] = {}
      @all_ratings.each do |rating|
        session[:ratings][rating] = 1
      end
      @ratingSave = session[:ratings]
    end
    
    
    setSort
    
    
    
    @all_ratings.each do |rating|
      if !@ratingSave.nil? && @ratingSave.keys.include?(rating)
        @lists[rating] = 1
      end
    end
    session[:sort] = @sort

    session[:ratings] = @ratingSave
    
    
    @movies = Movie.order @sort
    if @ratingSave
      @movies = Movie.where(:rating => @ratingSave.keys).order @sort
    end
  end
  
  
  def setSort
    @sort = params[:sort] || session[:sort]
    if !(params[:sort] == session[:sort] && params[:ratings] == session[:ratings])
      params[:sort] = session[:sort] = @sort
      params[:ratings] = session[:ratings] = @ratingSave
      flash.keep
      redirect_to movies_path(:sort=>params[:sort], :ratings =>params[:ratings])
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
