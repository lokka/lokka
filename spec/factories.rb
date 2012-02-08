FactoryGirl.define do
  create_time = update_time = Time.parse("2011-01-09T05:39:08Z")
  create_time_tokyo = update_time_tokyo = Time.parse("2011-01-09T05:39:08+09:00")

  factory :user do
    sequence(:name){|n| "testuser#{n}" }
    hashed_password '6338db2314bba79531444996b780fa7036480733'
    salt '2Z4H4DzATC'
    permission_level 1
    created_at create_time
    updated_at update_time
  end

  factory :post do
    association :user
    sequence(:title){|n| "Test Post #{n}" }
    body "<p>Welcome to Lokka!</p><p><a href=""/admin/"">Admin login</a> (user / password : test / test)</p>"
    type 'Post'
    created_at create_time
    updated_at update_time
  end

  factory :post_with_slug, :parent => :post do
    slug 'welcome-lokka'
  end

  factory :kramdown, :parent => :post do
    title 'Markdown'
    body "# hi! \nmarkdown test"
    markup 'kramdown'
  end

  factory :redcloth, :parent => :post do
    title 'Textile'
    body "h1. hi!  \ntextile test"
    markup 'redcloth'
  end

  factory :wikicloth, :parent => :post do
    title 'MediaWiki'
    body "= hi! = \nmediawiki test"
    markup 'wikicloth'
  end
end
