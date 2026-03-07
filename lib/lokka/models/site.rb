# frozen_string_literal: true

class Site < ActiveRecord::Base
  SORT_COLUMNS = %w[id created_at updated_at].freeze
  ORDERS = %w[asc desc].freeze

  def per_page
    super.presence || '10'
  end

  def default_sort
    super.presence || 'created_at'
  end

  def default_order
    super.presence || 'desc'
  end

  def default_order_query_operator
    { default_sort.to_sym => default_order.to_sym }
  end

  def method_missing(method, *args)
    if method.to_s =~ /=$/
      super
    else
      option = Option.find_or_initialize_by(name: method.to_s)
      option.value
    end
  end

  def respond_to_missing?(method, include_private = false)
    !method.to_s.end_with?('=') || super
  end
end

def Site
  Site.first
end
