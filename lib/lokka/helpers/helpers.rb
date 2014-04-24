require 'digest/sha1'

module Lokka
  module Helpers
    include Rack::Utils

    alias :h :escape_html

    %w[index search category tag yearly monthly daily post page entry entries].each do |name|
      define_method("#{name}?") do
        @theme_types.include?(name.to_sym)
      end
    end

    def base_url
      default_port = (request.scheme == "http") ? 80 : 443
      port = (request.port == default_port) ? "" : ":#{request.port.to_s}"
      "#{request.scheme}://#{request.host}#{port}"
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
        redirect to('/admin/login')
        return false
      end
    end

    def current_user
      logged_in? ? User.where(id: session[:user]).first : GuestUser.new
    end

    def logged_in?
      !!session[:user]
    end

    def bread_crumb
      @bread_crumbs[0..-2].inject('<ol>') do |html,bread|
        html += "<li><a href=\"#{bread[:link]}\">#{bread[:name]}</a></li>"
      end + "<li>#{@bread_crumbs[-1][:name]}</li></ol>"
    end

    def comment_form
      haml :'lokka/comments/form', :layout => false
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

    def locale; I18n.locale end

    def redirect_after_edit(entry)
      name = entry.class.name.downcase.pluralize
      if entry.draft
        redirect to("/admin/#{name}?draft=true")
      else
        redirect to("/admin/#{name}/#{entry.id}/edit")
      end
    end

    def render_preview(entry)
      @entry = entry
      @entry.user = current_user
      @entry.title << ' - Preview'
      @entry.updated_at = DateTime.now
      @comment = @entry.comments.new
      setup_and_render_entry
    end

    def setup_and_render_entry
      @theme_types << :entry

      type = @entry.class.name.downcase.to_sym
      @theme_types << type
      instance_variable_set("@#{type}", @entry)

      @title = @entry.title

      @bread_crumbs = [{ name: t('home'), link: '/' }]
      if @entry.category
        @bread_crumbs << { name: @entry.category.title, link: @entry.category.link }
      end
      @bread_crumbs << { name: @entry.title, link: @entry.link}

      render_detect_with_options [type, :entry]
    end

    ##
    # Gravatar profile image from email
    #
    # @param [String] Email address
    # @param [Integer] Image size (width and height)
    # @return [String] Image url
    #
    def gravatar_image_url(email = nil, size = nil)
      url = 'http://www.gravatar.com/avatar/'
      url += if email
        Digest::MD5.hexdigest(email)
      else
        '0' * 32
      end
      size ? "#{url}?size=#{size}" : url
    end

    class TranslateProxy
      def initialize(logger)
        @logger = logger
      end
      def method_missing(name, *args)
        name = name.to_s
        @logger.warn %|"t.#{name}" translate style is obsolete. use "t('#{name}')".| # FIXME
        I18n.translate(name)
      end
    end

    def translate_compatibly(*args)
      if args.length == 0
        TranslateProxy.new(logger)
      else
        I18n.translate(*args)
      end
    end
    alias_method :t, :translate_compatibly

    class << self
      include Lokka::Helpers
    end

    def mobile?
      request.user_agent =~ /iPhone|Android/
    end

    def slugs
      tmp = @theme_types
      tmp << @entry.slug    if @entry and @entry.slug
      tmp << @category.slug if @category and @category.slug
      tmp
    end

    def body_attrs
      {:class => slugs.join(' ')}
    end
  end
end
