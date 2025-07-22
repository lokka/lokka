# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.

# Create admin user
user = User.find_or_create_by!(name: 'admin') do |u|
  u.email = 'admin@example.com'
  u.password = 'password'
  u.password_confirmation = 'password'
  u.permission_level = 1
end

puts "User created: #{user.name}"

# Create site configuration
site = Site.find_or_create_by!(id: 1) do |s|
  s.title = 'Lokka Rails'
  s.description = 'A CMS built with Ruby on Rails'
end

puts "Site created: #{site.title}"

# Create sample category
category = Category.find_or_create_by!(name: 'General')

puts "Category created: #{category.name}"

# Create sample post
post = Post.find_or_create_by!(title: 'Hello World') do |p|
  p.body = '<p>Welcome to Lokka Rails! This is your first post.</p><p>Lokka has been successfully migrated from DataMapper + Sinatra to ActiveRecord + Rails 8.</p>'
  p.user = user
  p.category = category
  p.markup = 'html'
  p.draft = false
end

puts "Post created: #{post.title}"
