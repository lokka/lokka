module Pyha
  module Helpers
    def index?;     @theme_types.include?(:index); end
    def search?;    @theme_types.include?(:search); end
    def category?;  @theme_types.include?(:category); end
    def tag?;       @theme_types.include?(:tag); end
    def yearly?;    @theme_types.include?(:yearly); end
    def monthly?;   @theme_types.include?(:monthly); end
    def daily?;     @theme_types.include?(:daily); end
    def entry?;     @theme_types.include?(:entry); end
    def entries?;   @theme_types.include?(:entries); end

    def hash_to_query_string(hash)
      hash.collect {|k,v| "#{k}=#{v}"}.join('&')
    end

    def login_required
      if current_user.class != GuestUser
        return true
      else
        session[:return_to] = request.fullpath
        redirect '/admin/login'
        return false
      end
    end

    def current_user
      if session[:user]
        User.get(session[:user])
      else
        GuestUser.new
      end
    end

    def logged_in?
      !!session[:user]
    end

    def bread_crumb
      html = '<ol>'
      @bread_crumbs.each do |bread|
        html += '<li>'
        if bread.last?
          html += bread.name
        else
          html += "<a href=\"#{bread.link}\">#{bread.name}</a>"
        end
        html += '</li>'
      end
      html += '</ol>'
      html
    end

    def category_tree(categories = Category.roots)
      html = '<ul>'
      categories.each do |category|
        html += '<li>'
        html += "<a href=\"#{category.link}\">#{category.title}</a>"
        if category.children.count > 0
          html += category_tree(category.children)
        end
        html += '</li>'
      end
      html += '</ul>'
      html
    end

    def render_detect(*names)
      ret = ''
      names.each do |name|
        out = render_any(name)
        unless out.blank?
          ret = out
          break
        end
      end

      if ret.blank?
        raise Pyha::NoTemplateError, 'Template not found.'
      else
        ret
      end
    end

    def partial(name, options = {})
      options[:layout] = false
      render_any(name, options)
    end

    def render_any(name, options = {})
      ret = ''
      settings.supported_templates.each do |ext|
        out = rendering(ext, name, options)
        unless out.blank?
          ret = out
          break
        end
      end
      ret
    end

    def rendering(ext, name, options = {})
      locals = options[:locals] ? {:locals => options[:locals]} : {}
      dir = request.path_info =~ %r{^/admin/.*} ? 'admin' : "theme/#{@theme.name}"
      layout = "#{dir}/layout"
      path = "#{dir}/#{name}"

      logger.debug "ext, name, theme, dir, file: #{ext}, #{name}, #{@theme.name}, #{dir}, #{settings.views}/#{path}.#{ext}"

      if File.exist?("#{settings.views}/#{layout}.#{ext}")
        options[:layout] = layout.to_sym if options[:layout].nil?
      end
      if File.exist?("#{settings.views}/#{path}.#{ext}")
        send(ext.to_sym, path.to_sym, options, locals)
      end
    end

    def link_to(name, url, options = {})
      attrs = {:href => url}
      if options[:confirm] and options[:method]
        attrs[:onclick] = "if(confirm('#{options[:confirm]}')){var f = document.createElement('form');f.style.display = 'none';this.parentNode.appendChild(f);f.method = 'POST';f.action = this.href;var m = document.createElement('input');m.setAttribute('type', 'hidden');m.setAttribute('name', '_method');m.setAttribute('value', '#{options[:method]}');f.appendChild(m);f.submit();};return false"
      end

      str = ''
      attrs.each do |key, value|
        str += %Q(#{key.to_s}="#{value}")
      end

      %Q(<a #{str}>#{name}</a>)
    end

    def select_field(object, method, values = [], options = {})
      name = "#{object.class.name.downcase}[#{method}]"
      v = object.send(method)

      attrs = ''
      options.each do |key, value|
        attrs += %Q( #{key}="#{value}")
      end

      html = %Q(<select name="#{name}"#{attrs}>)
      values.each do |value|
        padding = value[0] == v ? ' selected="selected"' : ''
        html += %Q(<option value="#{value[0]}"#{padding}>#{value[1]}</option>)
      end
      html + '</select>'
    end

    def months
      ms = {}
      Post.all.each do |post|
        m = post.created_at.strftime('%Y-%m')
        if ms[m].nil?
          ms[m] = 1
        else
          ms[m] += 1
        end
      end

      months = []
      ms.each do |m, count|
        year, month = m.split('-')
        months << OpenStruct.new({:year => year, :month => month, :count => count})
      end
      months.sort {|x, y| y.year + y.month <=> x.year + x.month }
    end
  end
end
