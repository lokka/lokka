module Lokka
  module ReadMore
    def self.registered(app)
      app.before '/index.atom' do
        delimiter = Option.read_more_delimiter
        delimiter = "----" if delimiter.blank?
        delimiter += "<br>"
        @posts = Post.page(params[:page], :per_page => settings.per_page)
        @posts.each do |post|
          unless (i = post.body.index(delimiter)).nil?
            post.body = post.body.slice(0, i) + post.body.slice(i + delimiter.length, post.body.length) 
          end
        end
        content_type = 'application/atom+xml;charset=utf-8'
        content =  builder :'system/index'
        halt 200, {'Content-Type' => content_type}, content
      end

      app.get '/admin/plugins/read_more' do
        haml :"plugin/lokka-read_more/views/index", :layout => :"admin/layout"
      end 

      app.put '/admin/plugins/read_more' do
        Option.read_more_delimiter = params['delimiter']
        Option.read_more_text = params['text']
        Option.read_more_class = params['class']
        flash[:notice] = t.read_more_updated
        redirect '/admin/plugins/read_more'
      end 
    end
  end

  module Helpers
    def body_with_more(o)
      delimiter = Option.read_more_delimiter
      delimiter = "----" if delimiter.blank?
      delimiter += "<br>"
      unless (i = o.body.index(delimiter)).nil?
        body = o.body.slice(0, i)
        if @request.env['PATH_INFO'] == '/'
          text = Option.read_more_text
          text = t.read_more if text.blank?
          class_name = Option.read_more_class
          body += %Q(<a class="#{class_name}" href="/#{o.id}">#{text}</a>)
        else
          body += o.body.slice(i + delimiter.length, o.body.length) 
        end
      else
        o.body
      end
    end
  end
end
