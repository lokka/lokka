module Lokka
  module GitThemes
    def self.registered(app)
      app.set :git_themes, {}
      app.get '/admin/plugins/git_themes' do
        haml :"plugin/lokka-git_themes/views/index", :layout => :"admin/layout"
      end

      app.post '/admin/plugins/git_themes' do
        theme_url = params['theme_url']
        if theme_url =~ /^git:/
          user, theme_git = theme_url.split('/').last(2)
          theme_name = theme_git.split('.').first
          begin
            FileUtils.makedirs 'tmp/git_themes'
            FileUtils.chdir 'tmp/git_themes' do
              exec_git(theme_url)
              exts = settings.supported_templates.join(',')
              view_paths =
                Dir.glob("#{theme_name}/*.{#{exts}}").map do |path|
                  name, ext = path.split('.')
                  view = ::IO.respond_to?(:binread) ? ::IO.binread(path) : ::IO.read(path)
                  lines = view.count("\n") + 1
                  settings.templates["git:#{name}".to_sym] = [view, "git:#{path}", lines]
                  "git:#{path}"
                end
              screenshot_path = Dir.glob("#{theme_name}/screenshot.*").first
              settings.git_themes[theme_name] = OpenStruct.new(
                :git => theme_url,
                :assets_root => "http://#{user}.github.com/#{theme_name}",
                :view_paths => view_paths,
                :screenshot => screenshot_path ? "http://#{user}.github.com/#{screenshot_path}": nil)
            end
            flash[:notice] = 'Installed.'
          rescue Bundler::GitError
            flash[:notice] = 'Git error.'
          ensure
            FileUtils.rmtree 'tmp/git_themes', :secure => true
          end
        else
          flash[:notice] = 'Invalid URL.'
        end
        redirect '/admin/plugins/git_themes'
      end

      app.put '/admin/plugins/git_themes' do
        site = Site.first
        site.update(:theme => params[:title])
        flash[:notice] = t('theme_was_successfully_updated')
        redirect '/admin/plugins/git_themes'
      end

      app.delete '/admin/plugins/git_themes/:theme_name' do |theme_name|
        settings.templates.delete_if {|k, v| k.to_s.start_with? "git:#{theme_name}/" }
        settings.git_themes.delete(theme_name)
        site = Site.first
        if site.theme == theme_name
          site.update(:theme => 'jarvi')
          flash[:notice] = 'Removed and Changed theme to default.'
        else
          flash[:notice] = 'Removed.'
        end
        redirect '/admin/plugins/git_themes'
      end
    end
  end

  module Helpers
    def exec_git(path)
      command = %|clone "#{Shellwords.shellescape(path)}"|
      out = %x{git #{command}}

      if $?.exitstatus != 0
        msg = "Git error: command `git #{command}` in directory #{Dir.pwd} has failed."
        msg << "\nIf this error persists you could try removing the cache directory 'tmp/git_themes'"
        raise Bundler::GitError, msg
      end
      puts out # better way to debug?
      out
    end

    def selected_if(cond)
      cond ? 'selected' : nil 
    end

    # override
    def rendering(ext, name, options = {})
      locals = options[:locals] ? {:locals => options[:locals]} : {}
      dir =
        if request.path_info =~ %r{^/admin/.*}
          'admin'
        else
          "theme/#{@theme.name}"
        end

      layout = "#{dir}/layout"
      path =
        if settings.supported_stylesheet_templates.include?(ext)
          "#{name}"
        else
          "#{dir}/#{name}"
        end

      if File.exist?("#{settings.views}/#{layout}.#{ext}")
        options[:layout] = layout.to_sym if options[:layout].nil?
      elsif t = settings.templates["git:#{@theme.name}/layout".to_sym] and
            t[1].end_with?(".#{ext}")
        options[:layout] = "git:#{@theme.name}/layout".to_sym if options[:layout].nil?
      end
      if File.exist?("#{settings.views}/#{path}.#{ext}")
        send(ext.to_sym, path.to_sym, options, locals)
      elsif t = settings.templates["git:#{@theme.name}/#{name}".to_sym] and
            t[1].end_with?(".#{ext}")
        @theme.instance_variable_set :@path, settings.git_themes[@theme.name].assets_root
        send(ext.to_sym, "git:#{@theme.name}/#{name}".to_sym, options, locals)
      end
    end
  end
end

begin
  require 'shellwords' # There exists on ruby 1.9.2
rescue LoadError
  module Shellwords
    def shellescape(str)
      # An empty argument will be skipped, so return empty quotes.
      return "''" if str.empty?

      str = str.dup

      # Process as a single byte sequence because not all shell
      # implementations are multibyte aware.
      str.gsub!(/([^A-Za-z0-9_\-.,:\/@\n])/n, "\\\\\\1")

      # A LF cannot be escaped with a backslash because a backslash + LF
      # combo is regarded as line continuation and simply ignored.
      str.gsub!(/\n/, "'\n'")

      return str
    end
    module_function :shellescape
  end
end