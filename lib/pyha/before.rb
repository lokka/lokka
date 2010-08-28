module Pyha
  module Before
    def self.registered(app)
      app.before do
        @site = Site.first
        @title = @site.title
        @theme = Theme.new(settings.theme)
        @theme_types = []
  
        years = {}
        year_months = {}
        year_month_days = {}
        Post.all.each do |post|
          year = post.created_at.strftime('%Y')
          if years[year].nil?
            years[year] = 1
          else
            years[year] += 1
          end
  
          year_month = post.created_at.strftime('%Y-%m')
          if year_months[year_month].nil?
            year_months[year_month] = 1
          else
            year_months[year_month] += 1
          end
  
          year_month_day = post.created_at.strftime('%Y-%m-%d')
          if year_month_days[year_month_day].nil?
            year_month_days[year_month_day] = 1
          else
            year_month_days[year_month_day] += 1
          end
        end
        @years = []
        years.each do |year, count|
          @years << OpenStruct.new({:year => year, :count => count})
        end
        @years.sort! {|x, y| y.year <=> x.year }
        @year_months = []
        year_months.each do |year_month, count|
          year, month = year_month.split('-')
          @year_months << OpenStruct.new({:year => year, :month => month, :count => count})
        end
        @year_months.sort! {|x, y| y.year + y.month <=> x.year + x.month }
        @year_month_days = []
        year_month_days.each do |year_month_day, count|
          year, month, day = year_month_day.split('-')
          @year_month_days << OpenStruct.new({:year => year, :month => month, :day => day, :count => count})
        end
        @year_month_days.sort! {|x, y| y.year + y.month + y.day <=> x.year + x.month + x.day }
      end
    end
  end
end
