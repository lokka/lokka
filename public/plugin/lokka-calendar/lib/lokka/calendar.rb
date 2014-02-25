module Lokka
  module Calendar
    def self.registered(app)
      app.before do
        path = request.env['PATH_INFO']
        @calendar = Date.today

        if /^\/([\d]{4})\/([\d]{2})\/$/ =~ path
          @calendar = Date.new($1.to_i, $2.to_i, 1)
        elsif /^\/([\d]{4})\/([\d]{2})\/([\d]{2})\/$/ =~ path
          @calendar = Date.new($1.to_i, $2.to_i, $3.to_i)
        end

        content_for :header do
          haml :'plugin/lokka-calendar/views/header', :layout => false
        end
      end

      app.get %r{^/([\d]{4})/([\d]{2})/([\d]{2})/$} do |year, month, day|
        @theme_types << :monthly
        @theme_types << :entries

        y, m, d = year.to_i, month.to_i, day.to_i
        @posts = Post.published.all(:created_at.gte => DateTime.new(y, m, d)).
                      all(:created_at.lt => DateTime.new(y, m, d) + 1).
                      page(params[:page], :per_page => settings.per_page)

        @title = "#{year}/#{month}/#{day} - #{@site.title}"

        @bread_crumbs = []
        @bread_crumbs.push({:name => t.home, :link => '/'})
        @bread_crumbs.push({:name => "#{year}", :link => "/#{year}/"})
        @bread_crumbs.push({:name => "#{year}/#{month}", :link => "/#{year}/#{month}/"})
        @bread_crumbs.push({:name => "#{year}/#{month}/#{day}", :link => "/#{year}/#{month}/#{day}/"})

        render_detect :monthly, :entries
      end
    end
  end

  module Helpers
    def calendar
      @calendar_days = []
      @today = @calendar || Date.today
      next_month = @today >> 1

      @calendar_posts = []
      posts = Post.published.all(:fields => [:created_at]).
        all(:created_at.gte => DateTime.new(@today.year, @today.month, 1)).
        all(:created_at.lt => DateTime.new(@today.year, @today.month, 1) >> 1)
      posts.each do |post|
        @calendar_posts << Date.new(post.created_at.year, post.created_at.month, post.created_at.day)
      end
      @calendar_posts.uniq!

      first_day = Date.new(@today.year, @today.month, 1)
      @calendar_prev = @calendar << 1
      @calendar_next = @calendar >> 1
      last_day = Date.new(next_month.year, next_month.month, 1) - 1

      first_day = first_day - first_day.wday
      last_day = last_day + (6 - last_day.wday)

      first_day.upto(last_day) {|d| @calendar_days << d}

      haml :'plugin/lokka-calendar/views/index', :layout => false
    end
  end
end
