require 'kana'
module Ferret_Parser
	attr_accessor :index

	def parse(str); str; end

	def find(query, offset, limit)
		search parse(convert_str(query).to_s), offset, limit
	end

	def convert_str(str) # justify width of multibyte chars
		::Kana.kana(str, "nrKsa")
	end

	def pager(obj, query, total, offset, limit, page)
		#calc prev and next page number
		pages = total / limit + 1
		if page > 1 || pages == 1
			previous_page = nil
		else
			previous_page = page - 1
		end
		if page < pages
			next_page = page + 1
		else
			next_page = nil
		end

		# obj must have pager object
		pager_obj = Object.new
		pager_obj.class_eval do
			attr_accessor :previous_page, :next_page
		end
		pager_obj.previous_page = previous_page
		pager_obj.next_page = next_page
		obj.class_eval do
			attr_accessor :pager
		end
		obj.pager = pager_obj
		obj
	end

	def fix_text(highlight, str) # ferret returns excerpt body content, if possible
		if highlight == nil
			if str.length > 150
				str = '…' + str.split(//u)[0..150].join  + '…'
			end
			str.to_s.gsub(/\s(?=[^a-zA-Z])/, '') # crazy
		else
			highlight.to_s.gsub(/\s(?=[^a-zA-Z])/, '') #crazy
		end
	end

	def search(query, offset, limit, page)
		res = Array.new
		q = 'title|body:' + parse(query.strip)
		total = @index.search(q).total_hits
		if total > 0
			@index.search_each(q, :offset => offset, :limit => limit) do |id, score|
				row = @index[id]
				post = Object.new
				post.class_eval do
					attr_accessor :title, :id, :body, :created_at, :link, :edit_link, :type, :slug, :edit_link
				end

				highlight_body = @index.highlight(q, id,
					:field => :body,
					:pre_tag => '<span  style="background-color:Grey">',
					:post_tag => '</span>')
				highlight_title = @index.highlight(q, id,
					:field => :title,
					:pre_tag => '<span  style="background-color:Grey">',
					:post_tag => '</span>')
				post.title = fix_text highlight_title, row[:title]
				post.body = fix_text highlight_body, row[:body]

				post.id = row[:content_id]
				post.created_at = DateTime.parse(row[:created_at].gsub(/ \- /, '-'))
				type = row[:type].downcase.pluralize
				post.edit_link = "/admin/#{type}/#{row[:content_id]}/edit"

				if row[:slug] == ""
					post.link = "/#{row[:content_id]}"
				else
					post.link = "/#{row[:slug]}"
				end

				res << post
			end
		end
		pager(res, query, total, offset, limit, page)
	end
end

class Default_Parser
	include Ferret_Parser
	def initialize(arg); arg; end
end
