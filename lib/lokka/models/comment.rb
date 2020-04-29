# frozen_string_literal: true

class Comment < ActiveRecord::Base
  MODERATED = 0
  APPROVED  = 1
  SPAM      = 2

  belongs_to :entry

  validates :name, presence: true
  validates :body, presence: true
  validates_length_of :email, in: (0..40), if: ->(record) { record.email.present? }

  default_scope -> { order('created_at DESC') }

  scope :moderated, -> { where(status: MODERATED) }
  scope :approved,  -> { where(status: APPROVED) }
  scope :spam,      -> { where(status: SPAM) }
  scope :recent,
        ->(count = 5) { where(status: APPROVED).limit(count) }

  def link
    (entry ? "#{entry.link}#comment-#{id}" : '#')
  end
end
