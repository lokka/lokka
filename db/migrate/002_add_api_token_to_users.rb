# frozen_string_literal: true

class AddApiTokenToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :api_token, :string, limit: 64
    add_index :users, :api_token, unique: true
  end
end
