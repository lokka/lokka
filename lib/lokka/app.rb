# encoding: utf-8
require 'lokka'

module Lokka
  class App < Sinatra::Base
    include Padrino::Helpers::TranslationHelpers

    configure :development do
      register Sinatra::Reloader
    end

    configure do
      enable :method_override, :raise_errors, :static, :sessions
      disable :logging
      YAML::ENGINE.yamler = 'syck' if YAML.const_defined?(:ENGINE)
      register Padrino::Helpers
      set :app_file, __FILE__
      set :root, File.expand_path('../../..', __FILE__)
      set :public_folder => Proc.new { File.join(root, 'public') }
      set :views => Proc.new { public_folder }
      set :theme => Proc.new { File.join(public_folder, 'theme') }
      set :supported_templates => %w(erb haml slim erubis)
      set :supported_stylesheet_templates => %w(scss sass)
      set :per_page, 10
      set :admin_per_page, 200
      set :default_locale, 'en'
      set :haml, :ugly => false, :attr_wrapper => '"'
      supported_stylesheet_templates.each do |style|
        set style, :style => :expanded
      end
      ::I18n.load_path += Dir["#{root}/i18n/*.yml"]
      helpers Lokka::Helpers
      use Rack::Session::Cookie,
        :expire_after => 60 * 60 * 24 * 12
      set :session_secret, 'development' if development?
      use Rack::Flash
      Lokka.load_plugin(self)
      Lokka::Database.new.connect
    end

    load 'lokka/app/admin.rb'
    load 'lokka/app/entries.rb'

    not_found do
      if custom_permalink?
        r = custom_permalink_parse(request.path)

        return redirect(request.path.sub(/\/$/,"")) if /\/$/ =~ request.path

        url_changed = false
        [:year, :month, :monthnum, :day, :hour, :minute, :second].each do |k|
          i = (k == :year ? 4 : 2)
          (r[k] = r[k].rjust(i,'0'); url_changed = true) if r[k] && r[k].size < i
        end

        return redirect(custom_permalink_path(r)) if url_changed

        conditions, flags = r.inject([{},{}]) {|(conds, flags), (tag, value)|
          case tag
          when :year
            flags[:year] = value.to_i
            flags[:time] = true
          when :monthnum, :month
            flags[:month] = value.to_i
            flags[:time] = true
          when :day
            flags[:day] = value.to_i
            flags[:time] = true
          when :hour
            flags[:hour] = value.to_i
            flags[:time] = true
          when :minute
            flags[:minute] = value.to_i
            flags[:time] = true
          when :second
            flags[:second] = value.to_i
            flags[:time] = true
          when :post_id, :id
            conds[:id] = value.to_i
          when :postname, :slug
            conds[:slug] = value
          when :category
            conds[:category_id] = Category(value).id
          end
          [conds, flags]
        }

        if flags[:time]
          time_order = [:year, :month, :day, :hour, :minute, :second]
          args, last = time_order.inject([[],nil]) do |(result,last), key|
            break [result, key] unless flags[key]
            [result << flags[key], nil]
          end
          args = [0,1,1,0,0,0].each_with_index.map{|default,i| args[i] || default }
          conditions[:created_at.gte] = Time.local(*args)
          args[time_order.index(last)-1] += 1
          conditions[:created_at.lt] = Time.local(*args)
        end

        if @entry = Entry.first(conditions)
          status 200
          return setup_and_render_entry
        end
      end

      if output = render_any(:'404', :layout => false)
        output
      else
        haml :'404', :views => 'public/system', :layout => false
      end
    end

    error do
      'Error: ' + env['sinatra.error'].name
    end

    get '/*.css' do |path|
      content_type 'text/css', :charset => 'utf-8'
      render_any path.to_sym
    end

    run! if app_file == $0
  end
end
