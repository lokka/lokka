module Lokka
  module Links
    def self.registered(app)
      app.before do
        path = request.env['PATH_INFO']
        if /^\/admin/ =~ path
          haml :"plugin/lokka-links/views/aside", :layout => false
        end
      end

      app.get '/admin/plugins/links' do
        @links = Link.sorted
        haml :"plugin/lokka-links/views/index", :layout => :"admin/layout"
      end

      app.get '/admin/plugins/links/new' do
        @link = Link.new
        haml :"plugin/lokka-links/views/new", :layout => :"admin/layout"
      end

      app.post '/admin/plugins/links' do
        @link = Link.new(params[:link])
        if @link.save
          flash[:notice] = t.link_was_successfully_created
          redirect '/admin/plugins/links'
        else
          haml :"plugin/lokka-links/views/new", :layout => :"admin/layout"
        end
      end

      app.get '/admin/plugins/links/:id/up' do |id|
        link = Link.get(id)
        if link.sort > 1 && prevLink = Link.first(:sort => link.sort - 1)
          link.sort -= 1
          link.save
          prevLink.sort += 1
          prevLink.save
        end
        redirect '/admin/plugins/links'
      end

      app.get '/admin/plugins/links/:id/down' do |id|
        link = Link.get(id)
        if nextLink = Link.first(:sort => link.sort + 1)
          link.sort += 1
          link.save
          nextLink.sort -= 1
          nextLink.save
        end
        redirect '/admin/plugins/links'
      end

      app.get '/admin/plugins/links/:id/edit' do |id|
        @link = Link.get(id)
        haml :"plugin/lokka-links/views/edit", :layout => :"admin/layout"
      end

      app.put '/admin/plugins/links/:id' do |id|
        @link= Link.get(id)
        if @link.update(params[:link])
          flash[:notice] = t.link_was_successfully_updated
          redirect '/admin/plugins/links'
        else
          haml :"plugin/lokka-links/views/edit", :layout => :"admin/layout"
        end
      end

      app.delete '/admin/plugins/links/:id' do |id|
        if oldLink = Link.get(id)
          oldLink.destroy
          links = Link.all(:sort.gt => oldLink.sort)
          links.each do |link|
            link.sort -= 1
            link.save
          end
          flash[:notice] = t.link_was_successfully_deleted
        end
        redirect '/admin/plugins/links'
      end
    end
  end

  module Helpers
  end
end

class Link
  include DataMapper::Resource

  property :id, Serial
  property :title, String, :required => true
  property :url, String, :required => true, :format => :url
  property :target, String, :default => '_blank'
  property :sort, Integer, :required => true, :default => 1
  property :created_at, DateTime
  property :updated_at, DateTime

  before :save do
    if self.new? && link = Link.first(:order => :sort.desc)
      self.sort = link.sort + 1
    end
  end

  def self.sorted
    all(:order => [:sort.asc])
  end
end
