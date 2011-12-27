module Lokka
  module Redirectors
    def self.registered(app)
      app.before do
        path = request.env['PATH_INFO']

        if /^\/admin/ =~ path
          haml :"plugin/lokka-redirectors/views/aside", :layout => false 
        else
          redirects = Redirect.all
          redirects.each do |r|
            if Regexp.new(r.regex) =~ path
              response['Location'] = '/' + r.slug
              halt r.status_code
              break
            end
          end
        end
      end

      app.get '/admin/plugins/redirectors' do
        @redirects = Redirect.all(:order => :created_at.desc)
        haml :"plugin/lokka-redirectors/views/index", :layout => :"admin/layout"
      end

      app.get '/admin/plugins/redirectors/new' do
        @redirect = Redirect.new
        haml :"plugin/lokka-redirectors/views/new", :layout => :"admin/layout"
      end

      app.post '/admin/plugins/redirectors' do
        @redirect = Redirect.new(params[:redirect])
        if @redirect.save
          flash[:notice] = t.redirect_was_successfully_created
          redirect '/admin/plugins/redirectors'
        else
          haml :"plugin/lokka-redirectors/views/new", :layout => :"admin/layout"
        end
      end

      app.get '/admin/plugins/redirectors/:id/edit' do |id|
        @redirect = Redirect.get(id)
        haml :"plugin/lokka-redirectors/views/edit", :layout => :"admin/layout"
      end

      app.put '/admin/plugins/redirectors/:id' do |id|
        @redirect = Redirect.get(id)
        if @redirect.update(params[:redirect])
          flash[:notice] = t.redirect_was_successfully_updated
          redirect '/admin/plugins/redirectors'
        else
          haml :"plugin/lokka-redirectors/views/edit", :layout => :"admin/layout"
        end
      end

      app.delete '/admin/plugins/redirectors/:id' do |id|
        if r = Redirect.get(id)
          r.destroy
          flash[:notice] = t.redirect_was_successfully_deleted
        end
        redirect '/admin/plugins/redirectors'
      end
    end
  end

  module Helpers
    def slugs
      slugs = []
      entries = Entry.all(:fields => [:slug], :slug.not => nil, :slug.not => '')
      entries.each do |entry|
        slugs.push entry.slug unless entry.slug.blank?
      end
      slugs.sort
    end
  end
end

class Redirect
  include DataMapper::Resource

  property :id, Serial
  property :slug, Slug, :required => true, :length => 255
  property :regex, String, :required => true
  property :status_code, Integer, :default => 307
  property :created_at, DateTime
  property :updated_at, DateTime
end
