# frozen_string_literal: true

class Option < ActiveRecord::Base
  self.primary_key = 'name'

  validates :name, presence: true

  def self.method_missing(method, *args)
    attribute = method.to_s

    # Only handle simple option names; delegate everything else to super
    return super unless attribute =~ /\A[a-z][a-z0-9_]*=?\z/

    if attribute.end_with?('=')
      column = attribute.chomp('=')
      option = where(name: column).first_or_initialize
      option.value = args.first.to_s
      option.save
    else
      # Use raw SQL to avoid triggering AR method_missing recursion
      connection.select_value(
        "SELECT value FROM options WHERE name = #{connection.quote(attribute)}"
      )

    end
  end

  def self.respond_to_missing?(method, include_private = false)
    method.to_s =~ /\A[a-z][a-z0-9_]*=?\z/ ? true : super
  end
end
