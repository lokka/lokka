module Lokka
  module GoogleAnalytics
    def self.registered(app)
      app.get '/admin/plugins/google_analytics' do
        haml :"plugin/lokka-google_analytics/views/index", :layout => :"admin/layout"
      end

      app.put '/admin/plugins/google_analytics' do
        Option.tracker = params['tracker']
        Option.tracker_dn = params['tracker_dn']
        flash[:notice] = 'Updated.'
        redirect to('/admin/plugins/google_analytics')
      end

      app.before do
        tracker = Option.tracker
        if !tracker.blank? and ENV['RACK_ENV'] == 'production' and !logged_in?
          content_for :header do
            <<-EOS.strip_heredoc.html_safe
              <script>
                (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
                (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
                m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
                })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

                ga('create', '#{tracker}', 'auto');
                ga('send', 'pageview');
              </script>
            EOS
          end
        end
      end
    end
  end
end
