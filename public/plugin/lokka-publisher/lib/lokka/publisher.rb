require 'mechanize'

module Lokka
  module Publisher
    def self.registered(app)
      app.after "/admin/posts" do
        return unless request.request_method == "POST"
        return unless @entry
        return if params['preview']

        message = <<-BODY
#{@entry.user.name} が社内ブログに投稿しました。
"#{@entry.title}" #{base_url}#{@entry.link}
        BODY
        Lokka::Publisher::Leafy.new.post(message)
      end

      # comment
      app.after %r{^/([_/0-9a-zA-Z-]+)$} do |id_or_slug|
        return unless request.request_method == "POST"
        return unless @entry
        return unless @comment
        return if params['preview']

        message = <<-BODY
#{@comment.name} が社内ブログにコメントしました。
"#{@entry.title}" #{base_url}#{@comment.link}
        BODY
        Lokka::Publisher::Leafy.new.post(message)
      end
    end

    class Leafy
      def initialize
        settings = Settings.leafy
        @login_url = "https://#{settings.room}.#{settings.domain}/accounts/sign_in"
        @email = settings.email
        @password = settings.password
        @agent = Mechanize.new
      end

      def post(message)
        unless ENV.values_at("RACK_ENV", "LOKKA_ENV").include?("production")
          warn "Will post to leafy if production:\n#{message}"
          return
        end

        main_page = login!(@email, @password)
        form = main_page.form(id: 'new_status')
        form.field_with(name: 'status[text]').value = message
        @agent.submit(form)
      end

      def login!(email, password)
        logint_page = @agent.get(@login_url)
        form = logint_page.form
        form.field_with(name: 'user[email]').value = email
        form.field_with(name: 'user[password]').value = password
        @agent.submit(form)
      end
    end
  end
end
