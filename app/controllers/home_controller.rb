class HomeController < ApplicationController

 
  def index
     @dat=Detail.all
    if !Dir.exists?(Rails.root.join('filespace')) then
        Dir.mkdir(Rails.root.join('filespace'))
      #To store the uploaded files b4 RAIDing
      end
  end

  def upload
 uploaded_io = params[:file]
  File.open(Rails.root.join('filespace', uploaded_io.original_filename), 'wb') do |file|
    file.write(uploaded_io.read)
  end
    det= Detail.new
    det.filename=uploaded_io.original_filename
    det.status="LOCAL"
    det.preference="DROP"
    det.save
    redirect_to home_index_path
  end

  def download
    @file = params[:pa]
    send_file Rails.root.join('filespace',  @file),  :x_sendfile=>true
  end

  def delete
      file = params[:pa]
      det =Detail.find_by(filename: file)
      File.delete(Rails.root.join('filespace', det.filename))
      det.destroy 
      redirect_to :controller => "home",:action => 'index'
  end

  def preference
  end
end
