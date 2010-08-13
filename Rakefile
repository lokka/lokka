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

  # post
  (1..11).each do |i|
    Post.create(
      :title => "title... #{i}",
      :body  => "body... #{i}"
    )
  end
  
  # site
  Site.create(:name => 'title', :value => 'Test Site')
  Site.create(:name => 'description', :value => 'description...')
  Site.create(:name => 'theme', :value => 'default')
end

desc 'Reset database'
task 'db:reset' => %w(db:migrate db:seed)

desc 'Bundler'
task :bundle do
  `bundle install bundle  --without production`
end

desc 'Rebundler'
task :rebundle do
  `bundle install bundle --without production`
end

desc 'Install'
task :install => %w(bundle db:reset)

desc 'Reinstall'
task :reinstall => %w(rebundle db:reset)
