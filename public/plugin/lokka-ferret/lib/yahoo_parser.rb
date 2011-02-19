require 'uri'
require 'json'
require 'open-uri'
require 'rexml/document'

class Yahoo_Parser
	include ::Ferret_Parser

	def initialize(yahoo_id)
		@yahoo_id = yahoo_id
		@yahoo_url = 'http://jlp.yahooapis.jp/MAService/V1/parse?'
	end

	def parse(str)
		url = @yahoo_url + "appid=#{@yahoo_id}&sentence=#{URI.encode(str)}&results=ma&response=surface"
		tokens = []
		begin
			open(url) do |f|
				doc = REXML::Document.new(f)
				doc.elements.each('ResultSet/ma_result/word_list/word/surface') do |elem|
					tokens << elem.text
				end
			end
			tokens.inject{|token| ' ' + token.to_s}
		rescue SocketError
			str
		rescue OpenURI::HTTPError
			str
		end
	end

	def find(query, offset, limit)
		search parse(convert_str(query).to_s), offset, limit
	end
end

