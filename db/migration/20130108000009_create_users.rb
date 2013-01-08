class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :id
      t.string  :name,             limit: 40, unique: true
      t.string  :email,            limit: 40, unique: true
      t.string  :password_digest,  limit: 60
      t.integer :permission_level, default: 1

      t.timestamps
    end
  end
end
