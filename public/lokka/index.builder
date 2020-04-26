# frozen_string_literal: true

port = request.port == 80 ? '' : ':' + request.port.to_s
base_url = request.scheme + '://' + request.host + port

xml.instruct! :xml, version: '1.0'
xml.feed(xmlns: 'http://www.w3.org/2005/Atom') do
  xml.id      base_url + '/'
  xml.title   @site.title
  xml.updated @posts.first.updated_at.to_s
  xml.link    type: 'text/html', rel: 'alternate', href: base_url + '/'
  xml.link    type: 'application/atom+xml', ref: 'self', href: base_url + '/index.atom'

  @posts.each do |post|
    xml.entry do
      xml.id        'tag:' + base_url.gsub('http://', '') + ',' + post.created_at.to_s
      xml.title     post.title, type: 'html'
      xml.published post.created_at.to_s
      xml.updated   post.updated_at.to_s
      xml.link      type: 'html', rel: 'alternate', href: base_url + post.link
      xml.content   post.body, type: 'html'
      xml.author do
        xml.name post.user.nil? ? '' : post.user.name
      end
    end
  end
end
