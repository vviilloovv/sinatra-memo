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

  # find memo id
  def find_memo(id)
    memos.find { |memo| memo["id"] == id }
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
  redirect "/new" if params[:memo_body].empty?

  title = params[:memo_title].nil? ? "No Title" : params[:memo_title]
  body = params[:memo_body]
  #add_memo(title, body)

  redirect "/"
end

get "/show" do
  redirect "/" if params["id"].nil? || params["id"].empty?

  @page_title = "Show memo"
  @memo = find_memo(params["id"])
  redirect "/" if @memo.nil?
  erb :show
end

get "/edit" do
  redirect "/" if params["id"].nil? || params["id"].empty?

  @page_title = "Edit memo"
  @memo = find_memo(params["id"])
  redirect "/" if @memo.nil?
  erb :edit
end

delete "/edit" do
  erb :edit
end

