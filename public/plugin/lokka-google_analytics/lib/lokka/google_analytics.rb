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
          dn = Option.tracker_dn
          tracker_script = "<script type=\"text/javascript\">var _gaq=_gaq||[];_gaq.push(['_setAccount','#{tracker}']);"
          tracker_script += "_gaq.push(['_setDomainName', '.#{dn}']);" unless dn.blank?
          tracker_script += "_gaq.push(['_trackPageview']);(function(){var ga=document.createElement('script');ga.type='text/javascript';ga.async=true;ga.src=('https:'==document.location.protocol?'https://ssl':'http://www')+'.google-analytics.com/ga.js';var s=document.getElementsByTagName('script')[0];s.parentNode.insertBefore(ga,s);})();</script>"
          content_for :header do
            tracker_script
          end
        end
      end
    end
  end
end
