# frozen_string_literal: true

module Lokka
  class App
    namespace '/admin' do
      get '/' do
        @snippet = Snippet.where(name: 'Test Snippet').first
        haml :'admin/index', layout: :'admin/layout'
      end

      get '/login' do
        haml :'admin/login', layout: false
      end

      post '/login' do
        user = User.find_by_name(params['name'])
        if user.try(:authenticate, params['password'])
          session[:user] = user.id
          flash[:notice] = t('logged_in_successfully')
          if session[:return_to]
            redirect_url = session[:return_to]
            session[:return_to] = false
            redirect redirect_url
          else
            redirect to('/admin/')
          end
        else
          @login_failed = true
          haml :'admin/login', layout: false
        end
      end

      get '/logout' do
        session[:user] = nil
        redirect to('/admin/login')
      end

      # plugin
      get '/plugins' do
        haml :'admin/plugins/index', layout: :'admin/layout'
      end

      # site
      get '/site/edit' do
        @site = Site.first
        haml :'admin/site/edit', layout: :'admin/layout'
      end

      put '/site' do
        if Site.first.update_attributes(params['site'])
          flash[:notice] = t('site_was_successfully_updated')
          redirect to('/admin/site/edit')
        else
          haml :'admin/site/edit', layout: :'admin/layout'
        end
      end

      # import
      get '/import' do
        haml :'admin/import', layout: :'admin/layout'
      end

      post '/import' do
        file = params['import']['file'][:tempfile]

        if file
          Lokka::Importer::WordPress.new(file).import
          flash[:notice] = t('data_was_successfully_imported')
          redirect to('/admin/import')
        else
          haml :'admin/import', layout: :'admin/layout'
        end
      end

      # permalink
      get '/permalink' do
        @enabled = (Option.permalink_enabled == 'true')
        @format = Option.permalink_format || ''
        haml :'admin/permalink', layout: :'admin/layout'
      end

      put '/permalink' do
        errors = []

        if params[:enable] == '1'
          format = params[:format]
          format = "/#{format}" unless %r{^/} =~ format

          errors << t('permalink.error.no_tags') unless /%.+%/ =~ format
          errors << t('permalink.error.tag_unclosed') unless format.chars.select {|c| c == '%' }.size.even?
        end

        if errors.empty?
          Option.permalink_enabled = (params[:enable] == '1').to_s
          Option.permalink_format  = params[:format].sub(%r{/$}, '')
          flash[:notice] = t('site_was_successfully_updated')
        else
          flash[:error] = (['<ul>'] + errors.map {|e| "<li>#{e}</li>" } + ['</ul>']).join("\n")
          flash[:permalink_format] = format
        end

        redirect to('/admin/permalink')
      end
    end
  end
end
