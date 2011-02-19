require 'ferret'
require 'default_parser'

class Entry
	def ferret_index(ferret)
		unless self.draft
			doc = {}
			[:title, :body, :created_at, :type, :slug].each do |name|
				doc[name] = ferret.parse(self.__send__(name).to_s)
			end
			doc[:content_id] = self.id
			ferret.index << doc
			end
	end
end

module Lokka
	module Ferret
 		def self.registered(app)
			app.before do
				ferret_init
				method = request.env['REQUEST_METHOD']
				if @ferret_index_dir && (method == 'PUT' || method == 'POST')
					case 
					when request.env['PATH_INFO'] =~ /\/admin\/(posts|pages)(\/[\d]+\/edit)?/
						ferret = @ferret
						Entry.after :save do; ferret_index(ferret); end
					end
				end
			end

			# Al your /search/ is belong to us
			app.get '/search/' do
				ferret_init
				limit = settings.per_page
      	@theme_types << :search
      	@theme_types << :entries

				if !params[:query].blank? && @ferret_index_dir
					@query = params[:query]
					q = []
					page = params[:page] ? params[:page] : 1
					if page > 1
						offset = (page - 1) * limit + 1
					else
						offset = 0
					end
					@posts = @ferret.search(params[:query], offset, limit, page)
				else
      		@query = params[:query]
      		@posts = Post.search(@query).
      	              page(params[:page], :per_page => settings.per_page)
				end

      	@title = "Search by #{@query} - #{@site.title}"

      	@bread_crumbs = BreadCrumb.new
      	@bread_crumbs.add(t.home, '/')
      	@bread_crumbs.add(@query)

      	render_detect :search, :entries
			end

			# admin panel
			app.get '/admin/plugins/ferret' do
				login_required
				ferret_init
      	haml :"#{ferret_view}index", :layout => :"admin/layout"
			end

			app.put '/admin/plugins/ferret' do
				login_required
				ferret_init
				save = params[:ferret]
				if save['ferret_parse_method'] != 'yahoo'
					save['ferret_yahoo_id'] = ''
				end
				begin
					::Ferret::Index::Index.new(:path => save['ferret_index_dir'])
					if save['ferret_parse_method'] == 'yahoo' && save['ferret_yahoo_id'] == ''
						raise
					end
					Option.ferret_index_dir = save['ferret_index_dir']
					Option.ferret_parse_method = save['ferret_parse_method']
					Option.ferret_yahoo_id = save['ferret_yahoo_id']
				rescue
					flash[:notice] = t.ferret.index_dir_db_error
        	haml :"#{ferret_view}index", :layout => :"admin/layout"
				else
					flash[:notice] = t.ferret.index_dir_updated
					redirect '/admin/plugins/ferret'
				end
			end
		end
	end
	module Helpers
		def ferret_view
			"plugin/lokka-ferret/views/"
		end

		def ferret_init
			@ferret_index_dir = Option.ferret_index_dir unless @ferret_index_dir
			@ferret_parse_method = Option.ferret_parse_method unless @ferret_parse_method
			@ferret_yahoo_id = Option.ferret_yahoo_id unless @ferret_yahoo_id
			unless @ferret
				if @ferret_index_dir && @ferret_parse_method
					require "#{@ferret_parse_method}_parser"
					@ferret = ::Lokka.const_get("#{@ferret_parse_method.camelize}_Parser").new(@ferret_yahoo_id)
					index = ::Ferret::Index::Index.new(:path => @ferret_index_dir, :analyzer => ::Ferret::Analysis::WhiteSpaceAnalyzer.new, :auto_flush => true) 
					::Ferret.locale = 'ja_JP.UTF-8'
					@ferret.index = index
				end
			end
			unless @ferret_methods
				@ferret_methods = []
				@ferret_methods.push(['default', '--'])
				@ferret_methods.push(['mecab', 'MeCab'])
				@ferret_methods.push(['yahoo', 'Yahoo! API'])
			end
		end
	end
end

