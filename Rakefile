require 'main'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Pathname(__FILE__).dirname.realpath}/db.sqlite3")

desc 'Create the Pyha database'
task 'db:migrate' do
  DataMapper.auto_migrate!
end

desc 'Execute seed script'
task 'db:seed' do
  # user
  User.create(:name => 'komagata', :password => 'test', :password_confirmation => 'test')
  User.create(:name => 'test1', :password => 'test', :password_confirmation => 'test')

  # site
  Site.create(:name => 'title', :value => 'Test Site')
  Site.create(:name => 'description', :value => 'description...')
  Site.create(:name => 'theme', :value => 'default')

  # post
  (1..11).each do |i|
    Post.create(
      :user_id     => 1,
      :category_id => 1,
      :title       => "title... #{i}",
      :body        => "body... #{i}",
      :slug        => "slug-#{i}"
    )
  end

  # page
  (12..20).each do |i|
    Page.create(
      :user_id     => 1,
      :category_id => 1,
      :title       => "title... #{i}",
      :body        => "body... #{i}",
      :slug        => "slug-#{i}"
    )
  end

  # category
  Category.create(:name => 'category1', :slug => 'slug-1')
  Category.create(:name => 'category2', :slug => 'slug-2')
  Category.create(:name => 'category3', :slug => 'slug-3')
  Category.create(:name => 'category4', :slug => 'slug-4', :parent_id => 1)
  Category.create(:name => 'category5', :slug => 'slug-5', :parent_id => 1)
end

desc 'Reset database'
task 'db:reset' => %w(db:migrate db:seed)

desc 'Bundler'
task :bundle do
  `bundle install bundle --without production`
end

desc 'Rebundler'
task :rebundle do
  `bundle install bundle --without production`
end

desc 'Install'
task :install => %w(bundle db:reset)

desc 'Reinstall'
task :reinstall => %w(rebundle db:reset)
