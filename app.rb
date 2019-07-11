require "sinatra"
require "sinatra/reloader"

get "/" do
  @page_title = "Top"
  erb :index
end

get "/create" do
  @page_title = "New memo"
  erb :create
end

post "/create" do

  erb :create
end

