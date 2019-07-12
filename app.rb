require "sinatra"
require "sinatra/reloader"
require "json"

json_file_path = "./public/memos.json"

get "/" do
  @page_title = "Top"
  @memos = open(json_file_path) { |io| JSON.load(io) }["memos"]
  erb :index
end

get "/new" do
  @page_title = "New memo"
  erb :new
end

post "/new" do

  erb :new
end

get "/show" do
  @page_title = "Show memo"
  @memo = params[:memo]
  erb :show
end

get "/edit" do
  @page_title = "Edit memo"
  erb :edit
end

