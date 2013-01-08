# frozen_string_literal: true

FactoryGirl.define do
  create_time = update_time = Time.parse('2011-01-09T05:39:08Z')
  xmas = Time.parse('2011-12-25T19:00:00Z')
  newyear = Time.parse('2012-01-01T00:00:00Z')

  factory :site do
    title 'Test Site'
    description 'description...'
    dashboard %q(<p>Welcome to Lokka!</p><p>To post a new article, choose "<a href=\"/admin/posts/new\">New</a>" under "Posts" on the menu to the left. To change the title of the site, choose "Settings" on the menu to the left. (The words displayed here can be changed anytime through the "<a href=\"/admin/site/edit\">Settings</a>" screen.)</p>)
    theme 'jarvi'
    created_at create_time
    updated_at update_time
  end

  factory :user do
    sequence(:name){ |n| "testuser#{n}" }
    sequence(:email) { |n| "test_#{n}@test.com" }
    password 'test'
    password_confirmation 'test'
    permission_level 1
  end

  factory :post do
    association :user
    title "Test Post"
    body "<p>Welcome to Lokka!</p><p><a href=""/admin/"">Admin login</a> (user / password : test / test)</p>"
    type 'Post'
    created_at create_time
    updated_at update_time
  end

  factory :entry do
    association :user
    sequence(:title) {|n| "Test Post #{n}" }
    body '<p>Welcome to Lokka!</p><p><a href="/admin/">Admin login</a> (user / password : test / test)</p>'
    type 'Post'
    created_at create_time
    updated_at update_time
  end

  factory :post_with_slug, parent: :post do
    slug 'welcome-lokka'
  end

  factory :later_post_with_slug, parent: :post do
    title '1 day later'
    body '1 day passed'
    slug 'a-day-later'
    created_at create_time + 1.days
    updated_at update_time + 1.days
  end

  factory :xmas_post, parent: :post do
    created_at xmas
    updated_at xmas
  end

  factory :newyear_post, parent: :post do
    created_at newyear
    updated_at newyear
  end

  factory :kramdown, parent: :post do
    title 'Markdown'
    body "# hi! \nkramdown test"
    markup 'kramdown'
  end

  factory :redcloth, parent: :post do
    title 'Textile'
    body "h1. hi!  \n\nredcloth test"
    markup 'redcloth'
  end

  factory :wikicloth, :parent => :post do
    title 'MediaWiki'
    body "= hi! = \nmediawiki test"
    markup 'wikicloth'
  end

  factory :draft_post, :parent => :post do
    title 'Draft Post'
    draft true
    slug 'test-draft-post'
  end

  factory :draft_post_with_tag_and_category, parent: :draft_post do
    association :category
    after(:create) {|p| create(:tagging, taggable_id: p.id) }
  end

  factory :tag do
    sequence(:name){|n| "sample-tag-#{n}" }
  end

  factory :tagging do
    association :tag
    taggable_type 'Entry'
  end

  factory :snippet do
    sequence(:name) {|n| "Test Snippet#{n}" }
    body 'Text for test snippet.'
    created_at create_time
    updated_at update_time
  end

  factory :page do
    association :user
    sequence(:title) {|n| "Test Page #{n}" }
    body 'test Page'
    type 'Page'
    created_at create_time
    updated_at update_time
  end

  factory :draft_page, parent: :page do
    title 'Draft Page'
    body 'draft Page'
  end

  factory :category do
    sequence(:title) { |n| "Test Category #{n}" }
    sequence(:slug)  { |n| "category-slug-#{n}" }
    #created_at create_time
    #updated_at update_time
  end

  factory :category_child, parent: :category do
    title 'Test Child Category'
    created_at create_time
    updated_at update_time
  end


  # Comment has no association to entry by default
  factory :comment do
    status Comment::APPROVED
    name 'foobar'
    email 'foobar@example.com'
    body 'Test Comment'
    created_at create_time
    updated_at update_time
  end

  factory :spam_comment, class: Comment do
    status Comment::SPAM
    name 'spammer'
    email 'spammer@example.com'
    body 'Test Spam Comment'
    created_at create_time
    updated_at update_time
  end

  factory :field_name do
    sequence(:name) {|n| "Field Name #{n}" }
    created_at create_time
    updated_at update_time
  end
end
