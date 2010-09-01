require 'init'

task :default => :test

desc 'Run all tests'
task :test => 'test:prepare' do
   require 'rake/testtask'
   Rake::TestTask.new do |t|
      t.test_files = FileList[File.join('test', '**', '*_test.rb')]
   end
end

task :rcov do
  tests = Dir.glob('test/**/*_test.rb').join(' ')
  system "rcov -x bundle #{tests}"
end

desc 'Prepare test'
task 'test:prepare' => 'db:migrate' do
  User.create(:name => 'test', :password => 'test', :password_confirmation => 'test')
  Site.create(:title => 'Test Site', :description => 'description...', :theme => 'default')
  Post.create(
    :id          => 1,
    :user_id     => 1,
    :category_id => 1,
    :title       => "Test Post ...",
    :body        => "body ...",
    :slug        => "slug"
  )
end

desc 'Create the Pyha database'
task 'db:migrate' do
  User.auto_migrate!
  Site.auto_migrate!
  Entry.auto_migrate!
  Category.auto_migrate!
  Tag.auto_migrate!
  Tagging.auto_migrate!
  Comment.auto_migrate!
end

desc 'Execute seed script'
task 'db:seed' do
  # user
  User.create(:name => 'test', :password => 'test', :password_confirmation => 'test')

  # site
  Site.create(:title => 'Test Site', :description => 'description...', :theme => 'default')

  # post
  (1..11).each do |i|
    Post.create(
      :user_id     => 1,
      :category_id => 1,
      :title       => "Test Post ... #{i}",
      :body        => "body ... #{i}",
      :slug        => "slug-#{i}"
    )
  end

  # page
  (12..20).each do |i|
    Page.create(
      :user_id     => 1,
      :category_id => 1,
      :title       => "Test Page ... #{i}",
      :body        => "body ... #{i}",
      :slug        => "slug-#{i}"
    )
  end

  # category
  Category.create(
    :title   => 'Category 1',
    :slug    => 'slug-1')
  Category.create(
    :title   => 'Category 2',
    :slug    => 'slug-2')
  Category.create(
    :title   => 'Category 3',
    :slug    => 'slug-3')
  Category.create(
    :title   => 'Category 4',
    :slug    => 'slug-4',
    :parent_id => 1)
  Category.create(
    :title   => 'Category 5',
    :slug    => 'slug-5',
    :parent_id => 1)
end

desc 'Set database'
task 'db:set' => %w(db:migrate db:seed)

desc 'Reset database'
task 'db:reset' => %w(db:migrate db:seed)

desc 'Bundler'
task :bundle do
  `bundle install --without production`
end

desc 'Rebundler'
task :rebundle do
  `bundle install --without production`
end

desc 'Install'
task :install => %w(bundle db:reset)

desc 'Reinstall'
task :reinstall => %w(rebundle db:reset)


desc 'Import csv'
task 'import:csv' do
  require 'fastercsv'

  User.create(:name => 'test', :password => 'test', :password_confirmation => 'test')
  Site.create(:title => 'Test Site', :description => 'description...', :theme => 'default')

  FasterCSV.foreach('posts.csv', :headers => true) do |r|
    puts "#{r['id']}, #{r['title']}"
    Post.create(
      :id          => r['id'].to_i,
      :user_id     => 1,
      :title       => r['title'],
      :body        => r['body'],
      :created_at  => r['created_at'],
      :updated_at  => r['updated_at']
    )
  end

  FasterCSV.foreach('comments.csv', :headers => true) do |r|
    puts "#{r['id']}, #{r['url'].split('/')[-1]}, #{r['name']}"
    Comment.create(
      :id          => r['id'].to_i,
      :entry_id    => r['url'].split('/')[-1].to_i,
      :name        => r['name'],
      :homepage    => r['homepage'],
      :body        => r['body'],
      :created_at  => r['created_at'],
      :updated_at  => r['updated_at']
    )
  end
end
