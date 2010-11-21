module Lokka
	module Akismet
		def self.registered(app)
			app.get '/admin/plugins/akismet' do
				login_required
				@key = akismet_key
				if !@key
					redirect '/admin/plugins/akismet/install'
				else
        	haml :"#{akismet_view}akismet", :layout => :"admin/layout"
				end
			end

			app.put '/admin/plugins/akismet/install' do
				key = akismet_key
				if !key
					@akismet = Option.new
					@akismet.name = 'akismet_key'
					@akismet.value = params[:akismet][:akismet_key]
					if @akismet.save
						flash[:notice] = t.api_key_created
						redirect '/admin/plugins/akismet'
					else
        		haml :"#{akismet_view}install", :layout => :"admin/layout"
					end
				else
					params[:akismet_key][:name] = 'akismet_key'
					if Option.update(params[:akismet_key])
						flash[:notice] = t.api_key_created
						redirect '/admin/plugins/akismet'
					else
        		haml :"#{akismet_view}install", :layout => :"admin/layout"
					end
				end
			end

			app.get '/admin/plugins/akismet/install' do
				@akismet = Option.new
        haml :"#{akismet_view}install", :layout => :"admin/layout"
			end
		end
	end

	module Helpers
		def akismet_view
			'plugin/lokka-akismet/views/'
		end

		def akismet_key
			Option.akismet_key
		end
	end

end
