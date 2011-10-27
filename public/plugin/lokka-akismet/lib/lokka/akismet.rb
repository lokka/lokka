require 'net/http'
require 'uri'
Net::HTTP.version_1_2

module Lokka
	module Akismet
		def self.registered(app)
			app.before do
        path = request.env['PATH_INFO']
				if params["comment"] && /^\/admin\/comments/ !~ path
					if logged_in?
						params["comment"]["status"] = 1 # approved
					elsif spam?
						params["comment"]["status"] = 2 # spam
					else
						params["comment"]["status"] = 0 # moderated
					end
				end
			end

			app.get '/admin/plugins/akismet' do
				login_required
				@akismet = akismet_key
       	haml :"#{akismet_view}index", :layout => :"admin/layout"
			end

			app.put '/admin/plugins/akismet' do
				login_required
				posted_key = params[:akismet][:akismet_key].to_s
				if valid_akismet_key?(posted_key) && Option.akismet_key = params[:akismet][:akismet_key]
					flash[:notice] = rt.akismet.api_key_updated
					redirect '/admin/plugins/akismet'
				else
					flash[:notice] = rt.akismet.api_key_db_error
				end
        haml :"#{akismet_view}index", :layout => :"admin/layout"
			end
		end
	end

	module Helpers
		def akismet_view
			'plugin/lokka-akismet/views/'
		end

		def valid_akismet_key?(posted_key)
			request = "key=#{posted_key}&blog=#{akismet_blog}"
			response = akismet_post 'rest.akismet.com', '/1.1/verify-key', request
			if response == 'valid'
				true
			else
				false
			end
		end

		def spam?
			key = akismet_key
			if !key
				return false
			end
			host = "#{key}.rest.akismet.com"
			queries = []
			queries << "blog=#{akismet_blog}"
			queries << "user_ip=#{request.env["REMOTE_ADDR"]}"
			queries << "user_agent=#{request.env["HTTP_USER_AGENT"]}"
			queries << "referrer=#{request.env["HTTP_REFERER"]}"
			queries << "permalink=#{request.env["REQUEST_URI"]}"
			queries << "comment_type=comment"
			queries << "comment_author=#{params[:comment][:name]}"
			queries << "comment_author_email="
			queries << "comment_author_url=#{params[:comment][:homepage]}"
			queries << "comment_content=#{params[:comment][:body]}"
			queries.map!{|value|
				URI.encode(value)
			}
			request = queries.join("&")
			response = akismet_post host, '/1.1/comment-check', request

			if response == 'true'
				true
			else
				false
			end
		end

		def akismet_post(host, uri, request)
			response = ''
			Net::HTTP.start(host, 80) {|http|
   			response = http.post(uri,request)
   		}
			response.body
		end

		def akismet_blog
			"#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}/"
		end

		def akismet_key
			Option.akismet_key
		end
	end
end
