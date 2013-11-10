class GamesController < ApplicationController
  # GET /games
  # GET /games.json
  def index
    @games = Game.all.order_by([:date, :desc])
    @games.each do |game|
      if game.admin
        user = User.where({'twitter_id' => game.admin}).first
        game.author_handle = user.handle
        game.author_image = user.image
        game.save
      end
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @games }
      format.js { render :js => @games }
    end
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @game = Game.find(params[:id])
    @comment = Comment.new
    @comments = @game.comments.order_by([:date_time, :desc])
    w_api = Wunderground.new('fdb34ff48699837d')
    @weather = w_api.planner_for(@game.date, @game.date, @game.zip)
    # Variables for use inside of application.js
    gon.lat = @game.coordinates[0]
    gon.long = @game.coordinates[1]
    gon.location_marker = '../assets/icons/location-marker.png'
    if @game.admin
      @user = User.where({ 'twitter_id' => @game.admin }).first
    end
    @users = @game.users
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @game }
    end
  end

  # GET /games/new
  # GET /games/new.json
  def new
    @game = Game.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @game }
    end
  end

  # GET /games/1/edit
  def edit
    session[:return_to] ||= request.referer
    @game = Game.find(params[:id])
  end

  # POST /games
  # POST /games.json
  def create
    date = params[:game][:date].split('/')
    @game = Game.new(params[:game])
    @game.date = date[2] + '-' + date[0] + '-' + date[1]
    location_string = ''
    if @game[:location]
      location_string = @game[:location] if @game[:location]
      coordinates = Geocoder.coordinates(location_string)
      @game.coordinates = coordinates unless coordinates.nil?
    end
    if @game[:game_type]
      @game.tweet_text = 'Want to play some ' + @game[:game_type] + '? Meet me at ' + @game[:location] + ', ' + @game[:time] + ' on ' + @game[:date].to_s
    end
    if current_user
      @game.admin = @current_user.twitter_id
    end
    respond_to do |format|
      if @game.save
        if current_user
          add_user_to_game
          @game.admin = current_user.twitter_id
          @game.save
        end
        if ENV["TWITTER_POSTS_ENABLED"] == "TRUE"
          twitter = getTwitterClient
          game = params[:game]
          lat = @game.coordinates ? nil : coordinates[0]
          long = game.coordinates ? nil : coordinates[1]
          text = @game.tweet_text
          tweet = twitter.update(text, {:lat => lat, :long => long})
          @game.tweet_id = tweet[:id]
          @current_user.tweet_id = tweet[:id]
          @game.save
        end
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render json: @game, status: :created, location: @game }
      else
        format.html { render action: "new" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /games/1
  # PUT /games/1.json
  def update
    @game = Game.find(params[:id])

    respond_to do |format|
      if @game.update_attributes(params[:game])
        format.html { redirect_to session.delete(:return_to), notice: 'Game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { head :no_content }
    end
  end

  def join
    if current_user
      @game = Game.find(params[:id])
      joined_notification
      respond_to do |format|
        if add_user_to_game
          format.html { redirect_to @game, notice: 'Joined game.'}
          format.json { render json: @game }
          format.js
        else
          format.html { redirect_to @game, notice: 'Unable to join game.'}
          format.json { render json: @game }
          format.js
        end
      end
    else
      session["user_return_to"] = request.url
      redirect_to '/auth/twitter'
    end
  end

  def leave
    if current_user
      @game = Game.find(params[:id])
      leave_notification
      respond_to do |format|
        if remove_user_from_game
          format.html { redirect_to @game, notice: 'Left game.'}
          format.json { render json: @game }
          format.js
        else
          format.html { redirect_to @game, notice: 'You have to go to the game brah.'}
          format.json { render json: @game}
          format.js
        end
      end
    end
  end

  def filter
    @filter = params[:games_filter][:zip] ? params[:games_filter][:zip] : nil
    coordinates = Geocoder.coordinates(@filter)
    all_games = Game.all
    games = []

    all_games.each do |game|
      if coordinates
        distance = Geocoder::Calculations.distance_between(coordinates, game.coordinates)
        if distance <= 30
          games << game.id
        end
      end
    end
    @games = Game.any_in(:_id => games)
    @games = all_games if @filter.nil? || @filter == ''

    render :index
  end

  private
  def add_user_to_game
    @game.users.push(@current_user)
  end

  def remove_user_from_game
    @game.users.delete(@current_user)
  end
end
