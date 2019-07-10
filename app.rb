require "sinatra"
require "sinatra/reloader"

get "/" do
  @title = "Top"
  erb :index
end

get "/create" do
  @title = "New memo"
  erb :create
end

