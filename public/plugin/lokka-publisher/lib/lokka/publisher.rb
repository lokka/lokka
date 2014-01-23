require 'mechanize'

module Lokka
  module Publisher
    def self.registered(app)
      app.after "/admin/posts" do
        return unless request.request_method == "POST"
        return unless @entry
        return if params['preview']

        Lokka::Publisher::Leafy.publish!(@entry, base_url)
      end
    end

    class Leafy
      class << self
        def publish!(entry, base_url)
          message = <<-BODY
#{entry.user.name} が社内ブログに投稿しました。
"#{entry.title}" #{base_url}#{entry.link}
          BODY

          new.post(message)
        end
      end

      def initialize
        settings = Settings.leafy
        @login_url = "https://#{settings.room}.#{settings.domain}/accounts/sign_in"
        @email = settings.email
        @password = settings.password
        @agent = Mechanize.new
      end

      def post(message)
        return unless ENV['RACK_ENV'] == "production" || ENV['LOKKA_ENV'] == "production"

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
