# post
(1..11).each do |i|
  Post.create(
    :title => "title... #{i}",
    :body  => "body... #{i}"
  )
end

# setting
Setting.create(:name => 'theme', :value => 'default')
