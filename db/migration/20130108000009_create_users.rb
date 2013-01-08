class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :id
      t.string  :name,             limit: 40, unique: true
      t.string  :email,            limit: 40, unique: true
      t.string  :hashed_password,  limit: 50
      t.string  :salt,             limit: 50
      t.integer :permission_level, default: 1

      t.timestamps
    end
  end
end
