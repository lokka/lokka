module Pyha
  module Helpers
    def index?;     @theme_types.include?(:index); end
    def search?;    @theme_types.include?(:search); end
    def category?;  @theme_types.include?(:category); end
    def yearly?;    @theme_types.include?(:yearly); end
    def monthly?;   @theme_types.include?(:monthly); end
    def daily?;     @theme_types.include?(:daily); end
    def entry?;  @theme_types.include?(:entry); end
    def entries?; @theme_types.include?(:entries); end

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
      ret = nil
      names.each do |name|
        buf = render_any(name)
        unless buf.empty?
          ret = buf
          break
        end
      end
      ret
    end

    def render_any(name, options = {}, locals = {})
      ret = ''
      settings.supported_templates.each do |ext|
        if File.exist?("#{settings.views}/#{name}.#{ext}")
          ret = send(ext.to_sym, name.to_sym, options, locals)
          break
        end
      end
      ret
    end

    def partial(name, options = {})
      options.merge!(:layout => false)
      locals = options[:locals] ? {:locals => options[:locals]} : {}
      ret = ''
      settings.supported_templates.each do |ext|
        if File.exist?("#{settings.views}/#{name}.#{ext}")
          ret = send(ext.to_sym, name.to_sym, options, locals)
          break
        end
      end
      ret
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
  end
end
