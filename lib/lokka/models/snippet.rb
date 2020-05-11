# frozen_string_literal: true

class Snippet < ActiveRecord::Base
  validates :name,
            presence: true,
            uniqueness: true
  validates :body,
            presence:   true

  def edit_link
    "/admin/#{self.class.to_s.tableize}/#{id}/edit"
  end
end
