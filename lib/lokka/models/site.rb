# frozen_string_literal: true

class Site < ActiveRecord::Base
  SORT_COLUMNS = %w(id created_at updated_at)
  ORDERS = %w(asc desc)

  def per_page
    super || '10'
  end

  def default_order
    super.blank? ? 'created_at DESC' : "id #{super}"
  end

  def method_missing(method, *args)
    if method.to_s =~ /=$/
      super
    else
      option = Option.find_or_initialize_by(name: method)
      option.value
    end
  end
end
