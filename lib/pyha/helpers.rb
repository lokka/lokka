module Pyha
  module Helpers
    def index?;     @theme_types.include?(:index); end
    def search?;    @theme_types.include?(:search); end
    def category?;  @theme_types.include?(:category); end
    def yearly?;    @theme_types.include?(:yearly); end
    def monthly?;   @theme_types.include?(:monthly); end
    def daily?;     @theme_types.include?(:daily); end
    def document?;  @theme_types.include?(:document); end
    def documents?; @theme_types.include?(:documents); end
  
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
        User.get(:id => session[:user])
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
        html += "<a href=\"#{category.link}\">#{category.name}</a>"
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

    def render_any(name)
      ret = ''
      %w(erb haml).each do |ext|
        if File.exist?("#{settings.views}/#{name}.#{ext}")
          ret = send(ext, name)
          break
        end
      end
      ret
    end
  end
end
