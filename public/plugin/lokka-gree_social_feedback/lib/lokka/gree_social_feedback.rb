module Lokka
  module GreeSocialFeedback
    def self.registered(app)
      app.before do
        path = request.env['PATH_INFO']

        if /^\/([0-9a-zA-Z-]+)$/ =~ path
          content_for :header do
            haml :"plugin/lokka-gree_social_feedback/views/header", :layout => false
          end
        end
      end

      app.get '/admin/plugins/gree_social_feedback' do
        haml :"plugin/lokka-gree_social_feedback/views/index", :layout => :"admin/layout"
      end 

      app.put '/admin/plugins/gree_social_feedback' do
        params.each_pair do |key, value|
          eval("Option.#{key}='#{value}'") if key != '_method'
        end 
        flash[:notice] = t.gree_social_feedback_updated
        redirect '/admin/plugins/gree_social_feedback'
      end 
    end
  end

  module Helpers
    def html_properties 
      s = yield_content :html_properties
      s unless s.blank?
    end

    def gree_social_feedback(url = nil)
      url = URI.encode("#{env['rack.url_scheme']}://#{env['HTTP_HOST']}#{env['SCRIPT_NAME']}#{env['PATH_INFO']}") if url.blank?
      type = Option.gree_social_feedback_button
      if type.blank?
        type = "0"
        Option.gree_social_feedback_button = type
      end
      height = Option.gree_social_feedback_height
      if height.blank?
        height = "20" 
        Option.gree_social_feedback_height = "20"
      end
      %Q(<iframe src="http://share.gree.jp/share?url=#{url}&type=#{type}&height=#{height}" scrolling="no" frameborder="0" marginwidth="0" marginheight="0" style="border:none; overflow:hidden; width:100px; height:#{height}px;" allowTransparency="true"></iframe>)
    end
  end
end

class String
  def jleft(len)
    return "" if len <= 0

    str = self[0,len]
    return "" if str.length <= 0

    if /.\z/ !~ str
      str[-1,1] = ''
    end
    str
  end
end

