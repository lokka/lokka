FactoryGirl.define do
  create_time = update_time = Time.parse("2011-01-09T05:39:08Z")
  xmas = Time.parse("2011-12-25T19:00:00Z")
  newyear = Time.parse("2012-01-01T00:00:00Z")

  factory :site do
    title 'Test Site'
    description 'description...'
    dashboard %q(<p>Welcome to Lokka!</p><p>To post a new article, choose ""<a href=""/admin/posts/new"">New</a>"" under ""Posts"" on the menu to the left. To change the title of the site, choose ""Settings"" on the menu to the left. (The words displayed here can be changed anytime through the ""<a href=""/admin/site/edit"">Settings</a>"" screen.)</p>)
    theme 'jarvi'
    created_at create_time
    updated_at update_time
  end

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

  factory :later_post_with_slug, :parent => :post do
    title '1 day later'
    body '1 day passed'
    slug 'a-day-later'
    created_at create_time + 1.days
    updated_at update_time + 1.days
  end

  factory :xmas_post, :parent => :post do
    created_at xmas
    updated_at xmas
  end

  factory :newyear_post, :parent => :post do
    created_at newyear
    updated_at newyear
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

  factory :post_with_more, :parent => :post do
    body "a\n\n<!--more-->\n\nb\n\n<!--more-->\n\nc\n"
    slug 'post-with-more'
    markup 'kramdown'
  end

  factory :draft_post, :parent => :post do
    title 'Draft Post'
    draft true
    slug 'test-draft-post'
  end

  factory :draft_post_with_tag_and_category, :parent =>  :draft_post do
    association :category
    after_create { |p| Factory(:tagging, :taggable_id => p.id) }
  end

  factory :snippet do
    name 'Test Snippet'
    body 'Text for test snippet.'
    created_at create_time
    updated_at update_time
  end

  factory :page do
    association :user
    sequence(:title){|n| "Test Page #{n}" }
    body 'test Page'
    type 'Page'
    created_at create_time
    updated_at update_time
  end

  factory :draft_page, :parent => :page do
    title 'Draft Page'
    body 'draft Page'
  end

  factory :category do
    title 'Test Category'
    created_at create_time
    updated_at update_time
  end

  factory :tag do
    sequence(:name){|n| "sample-tag-#{n}" }
  end

  factory :tagging do
    association :tag
    tag_context 'tags'
    taggable_type Entry
  end
end
