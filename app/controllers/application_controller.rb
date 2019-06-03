require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end

  get "/" do
    erb :index
  end

  get "/signup" do
    erb :signup
  end

  post "/signup" do
    redirect '/failure' if params[:username].empty? || params[:password].empty?
    @user = User.new(username: params[:username], password: params[:password])
    if @user.save
      session[:user_id] = @user.id
      redirect '/login'
    else
      redirect '/failure'
    end
  end

  get '/account' do
    if !!session[:user_id]
      @user = User.find(session[:user_id])
      erb :account
    else
      redirect '/failure'
    end
  end

  get "/login" do
    erb :login
  end

  post "/login" do
    redirect '/failure' if params[:username].empty? || params[:password].empty?
    @current_user = User.find_by(username: params[:username])
    if @current_user.authenticate(params[:password])
      session[:user_id] = @current_user.id
      redirect "/account"
    else
      redirect "/failure"
    end
  end

  get "/failure" do
    erb :failure
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
