require "sinatra"
require "sinatra/reloader"
require "json"


helpers do
  def json_file_path
    "./memos.json"
  end

  # JSONファイル読み込み
  def memos
    open(json_file_path) { |io| JSON.load(io) }["memos"]
  end

  # IDからメモ検索
  def find_memo(id)
    memos.find { |memo| memo["id"] == id }
  end

  def dump_memos(new_memos)
    open(json_file_path, "w") { |io| JSON.dump( { "memos" => new_memos }, io) }
  end

  def add_memo(memo)
    dump_memos(memos << memo)
  end

  def delete_memo(id)
    dump_memos(memos.delete_if { |memo| memo["id"] == id })
  end

  def patch_memo(patch)
    new_memos = memos.each_with_object([]) do |memo, array|
      if memo["id"] == patch["id"]
        memo["title"] = patch["title"]
        memo["body"] = patch["body"]
      end
      array << memo
    end
    dump_memos(new_memos)
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

  add_memo(
    { "id" => Time.now.strftime("%Y%m%d%H%M%S"),
      "title" => params[:memo_title].empty? ? "John Doe's memo" : params[:memo_title],
      "body" => params[:memo_body], })

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
  delete_memo(params[:id])
  redirect "/"
end

patch "/edit" do
  redirect "/edit?id=#{params[:id]}" if params[:memo_body].empty?

  patch_memo(
    { "id" => params[:id],
      "title" => params[:memo_title].empty? ? "John Doe's memo" : params[:memo_title],
      "body" => params[:memo_body], })
  redirect "/"
end

