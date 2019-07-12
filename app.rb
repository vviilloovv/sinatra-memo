require "sinatra"
require "sinatra/reloader"
require "json"


helpers do
  def json_file_path
    "./memos.json"
  end

  # Load json file
  def memos
    open(json_file_path) { |io| JSON.load(io) }["memos"]
  end
end

get "/" do
  @page_title = "Top"
  @memos = memos
  erb :index
end

get "/new" do
  @page_title = "New memo"
  erb :new
end

post "/new" do
  if params[:memo_body].empty?
    redirect "/new"
  else
    title = params[:memo_title].nil? ? "No Title" : params[:memo_title]
    body = params[:memo_body]
    #add_memo(title, body)

    redirect "/"
  end
end

get "/show" do
  @page_title = "Show memo"
  @memo = memos.find { |memo| memo["id"] == params["id"] }
  erb :show
end

get "/edit" do
  @page_title = "Edit memo"
  erb :edit
end

