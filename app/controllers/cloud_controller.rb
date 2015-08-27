class CloudController < ApplicationController

   #dropbox constants  
  APP_KEY = 'frm9p5h8990e888'
  APP_SECRET = '5lnge08bkoauzhi'
  DROPREDIRECT_URI = 'http://localhost:3000/cloud/dropauth'

  require 'dropbox_sdk'
  require "google/api_client"
# require "google_drive"

def googoauth


   
      # Authorizes with OAuth and gets an access token.
      client = Google::APIClient.new
      auth = client.authorization
      auth.client_id = "4922426959-edjutam2uijumh3igkqabqifka4kgid8.apps.googleusercontent.com"
      auth.client_secret = "Ro_3g5hlKAM-u4JyUwzOjGL_"
      auth.scope = [
        "https://www.googleapis.com/auth/drive",
        "https://www.googleapis.com/auth/drive.file"
      ]
      auth.redirect_uri = "http://localhost:3000/cloud/googoauth"
      authorize_url=auth.authorization_uri(
    :approval_prompt => :force,
    :access_type => :offline,
    :user_id => 'jagan26@gmail',
    :state => 'qwe3421'
  ).to_s
    if params[:code]==nil
      
      redirect_to authorize_url

    else
      # print("1. Open this page:\n%s\n\n" % auth.authorization_uri)
      # print("2. Enter the authorization code shown in the page: ")
      
      # auth.code = params[:code]#$stdin.gets.chomp
      # auth.fetch_access_token!
      # access_token = auth.access_token

          cld=Cloud.last
          cld.goog=params[:code]
          puts "********************goog***********"
          
          # client.authorization.code = params[:code]#$stdin.gets.chomp  4/WqbBBr8xNBfNU7Bjk5XMrZ96L8QoRjlPOrfJS5jghLY
          # client.authorization.fetch_access_token!
          # cld.goog=client.authorization
          # cld.save
          puts "goog auth sucess!! Yayyyy"
          # puts cld.goog
          # redirect_to :controller => "cloud", :action => 'googup', :pa => client.authorization
               det =Detail.find_by(status: 'UPLOADING')
               if det != nil then
                   if det.preference == "GOOG" then
                    redirect_to :controller => "cloud", :action => 'googup', :pa => det.s3
                  elsif det.preference =="GOOG2" then
                    redirect_to :controller => "cloud", :action => 'googup', :pa => det.s1
                  end
              end
        end
        
      end

 
  def dropauth
    if params[:code]==nil
          session[:user]="jagan26@gmail.com"
          csrf_token_session_key = :dropbox_auth_csrf_token
          @@flow = DropboxOAuth2Flow.new(APP_KEY, APP_SECRET, DROPREDIRECT_URI, session, csrf_token_session_key)
          authorize_url = @@flow.start()
          redirect_to authorize_url
        else
          access_token, user_id= @@flow.finish(params)
          cld=Cloud.new
          cld.drop=access_token
          cld.save
          redirect_to :controller => "cloud", :action => 'boxauth'
          end
  end

  def boxauth
      if params[:code]==nil
          
            require 'ruby-box'
          session = RubyBox::Session.new({
            client_id: 'skamrg791rspftegmigusyevx2pup49y',
            client_secret: '6sj2CBbfGU0eFdfJojTxJOu36DtVyKG6'
          })
          authorize_url = session.authorize_url('http://localhost:3000/cloud/boxauth')
          redirect_to authorize_url
      else
        
          session = RubyBox::Session.new({
            client_id: 'skamrg791rspftegmigusyevx2pup49y',
            client_secret: '6sj2CBbfGU0eFdfJojTxJOu36DtVyKG6'
          })
           code=params[:code]
          @token = session.get_access_token(code)
          tok= @token.token # the access token.
           cld=Cloud.last
          cld.box=tok
          cld.save
          redirect_to :controller => "cloud", :action => 'googoauth'
      end
  end

  def dropup
    @file = params[:pa]
      cld=Cloud.last
                # Upload file code here
            access_token=cld.drop
            client = DropboxClient.new(access_token)
            puts "linked account:", client.account_info().inspect
            file = File.open(Rails.root.join('filespace', @file), 'r')#open('working-draft.txt')
            @t1= Time.now.strftime("%Y-%m-%d %H:%M:%S.%L");
            puts @t1
            puts "***********************Dropbox upload*****************************************************************"
            response = client.put_file(@file, file)
            @t2= Time.now.strftime("%Y-%m-%d %H:%M:%S.%L");
            file.close
            puts @t2
            
           puts "uploaded:", response.inspect
          redirect_to :controller => "cloud", :action => 'upload'
  end

  def boxup
    @file = params[:pa]
     
                # Upload file code here
        
           cld=Cloud.last
        tok=cld.box
            session = RubyBox::Session.new({
              client_id: 'skamrg791rspftegmigusyevx2pup49y',
              client_secret: '6sj2CBbfGU0eFdfJojTxJOu36DtVyKG6',
              access_token: tok
            })
            client = RubyBox::Client.new(session)
        pathh= (Rails.root.join('filespace', @file)).to_s
            @t1= Time.now.strftime("%Y-%m-%d %H:%M:%S.%L");
            puts @t1
            puts "***********************box upload*****************************************************************"
          
          file = client.upload_file(pathh, '/csc/', overwrite=true) # lookups by id are more efficient
          @t2= Time.now.strftime("%Y-%m-%d %H:%M:%S.%L");
            puts @t2
     redirect_to :controller => "cloud", :action => 'upload' 
    
  end

 def googup
     
      @file = params[:pa]
      client = Google::APIClient.new
        auth = client.authorization
        auth.client_id = "4922426959-edjutam2uijumh3igkqabqifka4kgid8.apps.googleusercontent.com"
        auth.client_secret = "Ro_3g5hlKAM-u4JyUwzOjGL_"
        auth.scope = [
          "https://www.googleapis.com/auth/drive",
          "https://www.googleapis.com/auth/drive.file"
        ]
        auth.redirect_uri = "http://localhost:3000/cloud/googoauth"
        authorize_url=auth.authorization_uri(
      :approval_prompt => :force,
      :access_type => :offline,
      :user_id => 'jagan26@gmail',
      :state => 'qwe3421'
      ).to_s
      client.authorization.code = Cloud.last.goog#$stdin.gets.chomp  4/WqbBBr8xNBfNU7Bjk5XMrZ96L8QoRjlPOrfJS5jghLY
      client.authorization.fetch_access_token!
      drive = client.discovered_api('drive', 'v2')
      file = drive.files.insert.request_schema.new({
            'title' => @file,
            'description' => 'avan poto',
            'mimeType' => 'image/jpeg'
              })
      # Set the parent folder.
      # if parent_id
      #   file.parents = [{'id' => parent_id}]
      # end
      media = Google::APIClient::UploadIO.new(Rails.root.join('filespace', @file).to_s, 'application/vnd.google-apps.unknown')
      puts "before upload before if"
     
      result = client.execute(
        :api_method => drive.files.insert,
        :body_object => file,
        :media => media,
        :parameters => {
          'uploadType' => 'multipart',
          'alt' => 'json'})
        puts "after upload before if"
                if result.status == 200

                puts "Inside if"
                  puts result.data['id']
                redirect_to :controller => "cloud", :action => 'upload', :gfid =>  result.data['id']
    
                else
                  puts "Inside else"
                  puts "An error occurred: #{result.data['error']['message']}"
                    redirect_to :controller => "home", :action => 'index'
                end
        
  end


  def splice
     det =Detail.find_by(filename: params[:pa])
     det.status="UPLOADING"
     det.save
     # split file here
     # ...
     # save split file names to db

    # get ranmdom names for split filespace
    letter = [('a'..'z'),('A'..'Z')].map { |i| i.to_a  }.flatten
    split1 = (0..8).map{ letter[rand(letter.length)]}.join
    det.s1=split1+".scs"
    letter = [('a'..'z'),('A'..'Z')].map { |i| i.to_a  }.flatten
    split2 = (0..8).map{ letter[rand(letter.length)]}.join
    det.s2=split2+".scs"
    letter = [('a'..'z'),('A'..'Z')].map { |i| i.to_a  }.flatten
    split3 = (0..8).map{ letter[rand(letter.length)]}.join
    det.s3=split3+".scs"


    # get ranmdom names for split filespace close
   # rec.status=true
    
    image_a = File.open(Rails.root.join('filespace', params[:pa]), 'r')
    image_b = File.open(Rails.root.join('filespace', det.s1), 'w+')
    image_c = File.open(Rails.root.join('filespace', det.s2), 'w+')
    image_d = File.open(Rails.root.join('filespace', det.s3), 'w+')

      n=3
      image_a.each_line do |l|
          if n%3==0
            image_b.write(l)    
          elsif n%3==1
             image_c.write(l)
           else
            image_d.write(l)
          end
        n=n+1
      end
  image_a.close
  image_b.close
  image_c.close
  image_d.close
 cld=Cloud.first
     if cld==nil then
      redirect_to cloud_dropauth_path
    else
      
       redirect_to :controller => "cloud", :action => 'upload'
         
    end
  end

  def upload
       det =Detail.find_by(status: 'UPLOADING')
       if det.preference == "DROP" then
        det.preference="DROP2"
        det.save
        redirect_to :controller => "cloud", :action => 'dropup', :pa => det.s1
      elsif det.preference == "DROP2" then
        det.preference="BOX"
        det.save
        redirect_to :controller => "cloud", :action => 'dropup', :pa => det.s2
      elsif det.preference="BOX" then
        det.preference="BOX2"
        det.save
        redirect_to :controller => "cloud", :action => 'boxup', :pa => det.s2
      elsif det.preference="BOX2" then
        det.preference="GOOG"
        det.save
        redirect_to :controller => "cloud", :action => 'boxup', :pa => det.s3
      elsif det.preference="GOOG" then
        det.preference="GOOG2"
        det.save
        redirect_to :controller => "cloud", :action => 'googoauth'
      elsif det.preference="GOOG2" then
        det.preference="ALLUP"
        det.googfid= params[:gfid]
        det.save
        redirect_to :controller => "cloud", :action => 'googoauth'
      elsif det.preference="ALLUP" then
        det.googfid2=params[:gfid]
        det.save
        File.delete(Rails.root.join('filespace', det.s1))
        File.delete(Rails.root.join('filespace', det.s2))
        File.delete(Rails.root.join('filespace', det.s3))
        File.delete(Rails.root.join('filespace', det.filename))
        redirect_to home_index_path
      end       
  end

  def download

    # # Download from dropbox
    @file=params[:pa]
     det =Detail.find_by(filename: params[:pa])
    #  access_token=Cloud.last.drop
    #     client = DropboxClient.new(access_token)
    #     @t1= Time.now.strftime("%Y-%m-%d %H:%M:%S.%L");
    #         puts @t1
    #         puts "***********************Dropbox Download*****************************************************************"
          
    #     contents, metadata = client.get_file_and_metadata(@file)
        
    #     File.open(Rails.root.join('filespace', @file), 'wb') {|f| f.puts contents }
    #    @t2= Time.now.strftime("%Y-%m-%d %H:%M:%S.%L");
    #         puts @t2
        # Download from box

        tok=Cloud.last.box
            session = RubyBox::Session.new({
              client_id: 'skamrg791rspftegmigusyevx2pup49y',
              client_secret: '6sj2CBbfGU0eFdfJojTxJOu36DtVyKG6',
              access_token: tok
            })
            client = RubyBox::Client.new(session)
      cfile='/csc/'+@file
      puts cfile
      @t1= Time.now.strftime("%Y-%m-%d %H:%M:%S.%L");
            puts @t1
            puts "***********************box Download*****************************************************************"
          
#           f = File.open(Rails.root.join('filespace', @file), 'wb')#open('./LOCAL.txt', 'w+')
# f.write( client.file('cfile').download )
# f.close()
      content = client.file(cfile).download 
      File.open(Rails.root.join('filespace', @file), 'wb') {|f| f.puts content }
      @t2= Time.now.strftime("%Y-%m-%d %H:%M:%S.%L");
            puts @t2
     det.status="LOCAL"
     det.save 
         redirect_to  home_index_path 
       end
end
