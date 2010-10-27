require './init'

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

desc 'Create the Lokka database'
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
  User.create(:name => 'test', :password => 'test', :password_confirmation => 'test')
  Site.create(:title => 'Test Site', :description => 'description...', :theme => 'default')
  Post.create(:title => "Test Post", :body => "Wellcome!<br /><a href=\"/admin/\">Admin login</a> (user / password : test / test)", :user_id => 1)
end

desc 'Set database'
task 'db:set' => %w(db:migrate db:seed)

desc 'Reset database'
task 'db:reset' => %w(db:migrate db:seed)

desc 'Install gems'
task :bundle do
  `bundle install --path bundle --without production test`
end

desc 'Install'
task :install => %w(bundle db:set)
