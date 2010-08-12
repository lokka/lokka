# post
(1..11).each do |i|
  Post.create(
    :title => "title... #{i}",
    :body  => "body... #{i}"
  )
end

# setting
Setting.create(:name => 'title', :value => 'Test Site')
Setting.create(:name => 'description', :value => 'description...')
Setting.create(:name => 'theme', :value => 'default')
