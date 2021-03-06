# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require "json"
require "securerandom"

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
    open(json_file_path, "r+") do |io|
      io.flock(File::LOCK_EX)
      io.truncate(0)
      JSON.dump({ "memos" => new_memos }, io)
    end
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
    "id" => SecureRandom.uuid,
    "title" => params[:memo_title].empty? ? "John Doe's memo" : params[:memo_title],
    "body" => params[:memo_body],)

  redirect "/"
end

get "/:id" do |id|
  @page_title = "Show memo"
  @memo = find_memo(id)
  redirect "/" if @memo.nil?
  erb :show
end

get "/:id/edit" do |id|
  @page_title = "Edit memo"
  @memo = find_memo(id)
  redirect "/" if @memo.nil?
  erb :edit
end

delete "/:id/edit" do |id|
  delete_memo(id)
  redirect "/"
end

patch "/:id/edit" do |id|
  redirect "/#{id}/edit" if params[:memo_body].empty?

  patch_memo(
    "id" => id,
    "title" => params[:memo_title].empty? ? "John Doe's memo" : params[:memo_title],
    "body" => params[:memo_body],)
  redirect "/"
end
