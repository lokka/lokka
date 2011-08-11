# encoding: utf-8
module Lokka
  module Helpers
    include Rack::Utils

    alias :h :escape_html

    %w[index search category tag yearly monthly daily post page entry entries].each do |name|
      define_method("#{name}?") do
        @theme_types.include?(name.to_sym)
      end
    end

    # h + n2br
    def hbr(str)
      h(str).gsub(/\r\n|\r|\n/, "<br />\n")
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
      logged_in? ? User.get(session[:user]) : GuestUser.new
    end

    def logged_in?
      !!session[:user]
    end

    def bread_crumb
      @bread_crumbs.breads[0..-2].inject('<ol>') do |html,bread|
        html += "<li><a href=\"#{bread.link}\">#{bread.name}</a></li>"
      end + "<li>#{@bread_crumbs.breads[-1].name}</li></ol>"
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
        raise Lokka::NoTemplateError, "Template not found. #{[names.join(', ')]}"
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
      templates = settings.supported_templates + settings.supported_stylesheet_templates
      templates.each do |ext|
        out = rendering(ext, name, options)
        out.force_encoding(Encoding.default_external) unless out.nil?
        unless out.blank?
          ret = out
          break
        end
      end
      ret
    end

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
      end
      if File.exist?("#{settings.views}/#{path}.#{ext}")
        send(ext.to_sym, path.to_sym, options, locals)
      end
    end

    def comment_form
      haml :'system/comments/form', :layout => false
    end

    def image_tag(src, options = {})
      %Q(<img src="#{src}" />)
    end

    def link_to(name, url, options = {})
      attrs = {:href => url}
      if options[:confirm] and options[:method]
        attrs[:onclick] = "if(confirm('#{options[:confirm]}')){var f = document.createElement('form');f.style.display = 'none';this.parentNode.appendChild(f);f.method = 'POST';f.action = this.href;var m = document.createElement('input');m.setAttribute('type', 'hidden');m.setAttribute('name', '_method');m.setAttribute('value', '#{options[:method]}');f.appendChild(m);f.submit();};return false"
      end

      options.delete :confirm
      options.delete :method

      attrs.update(options)

      str = ''
      attrs.each do |key, value|
        str += %Q( #{key.to_s}="#{value}")
      end

      %Q(<a#{str}>#{name}</a>)
    end

    def link_to_if(cond, name, url, options = {})
      cond ? link_to(name, url, options) : name
    end

    def link_to_unless(cond, name, url, options = {})
      link_to_if !cond, name, url, options
    end

    def link_to_current(name, url, options = {})
      request_path == url ? link_to(name, url, options) : name
    end

    def link_to_unless_current(name, url, options = {})
      request_path != url ? link_to(name, url, options) : name
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

    def truncate(text, options = {})
      options = {:length => 30, :omission => '...'}.merge(options)
      mb_text = text.mb_chars
      max_length = options[:length]
      mb_text.size > max_length ? mb_text.to_s.first(max_length) + options[:omission] : text
    end

    def strip_tags(text)
      text.gsub(/<.+?>/, '')
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

    def header
      s = yield_content :header
      s unless s.blank?
    end

    def footer
      s = yield_content :footer
      s unless s.blank?
    end

    # example: /foo/bar?buz=aaa
    def request_path
      path = '/' + request.url.split('/')[3..-1].join('/')
      path += '/' if path != '/' and request.url =~ /\/$/
      path
    end

    def locale; r18n.locale.code end
  end
end
