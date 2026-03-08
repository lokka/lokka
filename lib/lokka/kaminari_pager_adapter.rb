# frozen_string_literal: true

# Compatibility layer for old DataMapper pager API
# Used in templates like: @posts.pager.next_page
module KaminariPagerAdapter
  class Pager
    def initialize(relation)
      @relation = relation
    end

    def next_page
      @relation.next_page
    end

    def previous_page
      @relation.prev_page
    end

    def to_html(url)
      # Not implemented - templates should use Kaminari helpers directly
      ''
    end
  end

  def pager
    Pager.new(self)
  end
end

ActiveRecord::Relation.include(KaminariPagerAdapter)
