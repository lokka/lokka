created_at = updated_at = Time.parse("2011-01-09T05:39:08Z")
created_at_tokyo = updated_at_tokyo = Time.parse("2011-01-09T05:39:08+09:00")

Site.create!(:title => "Test Site",
             :description => "description...",
             :dashboard => %q(<p>Welcome to Lokka!</p><p>To post a new article, choose ""<a href=""/admin/posts/new"">New</a>"" under ""Posts"" on the menu to the left. To change the title of the site, choose ""Settings"" on the menu to the left. (The words displayed here can be changed anytime through the ""<a href=""/admin/site/edit"">Settings</a>"" screen.)</p>),
             :theme => "jarvi",
             :created_at => created_at,
             :updated_at => updated_at)

User.create!(:name => "test",
             :hashed_password => "6338db2314bba79531444996b780fa7036480733",
             :salt => "2Z4H4DzATC",
             :permission_level => 1,
             :created_at => created_at,
             :updated_at => updated_at)

# id 1
Entry.create!(:user_id => 1,
              :title => "Test Post",
              :body => "<p>Welcome to Lokka!</p><p><a href=""/admin/"">Admin login</a> (user / password : test / test)</p>",
              :type => "Post",
              :slug => 'welcome-lokka',
              :created_at => created_at,
              :updated_at => updated_at)

Snippet.create!(:id => 1,
                :name => "Test Snippet",
                :body => "Text for test snippet.",
                :created_at => created_at,
                :updated_at => updated_at)

Category.create(:id => 1,
                :title => 'Test Category',
                :created_at => created_at,
                :updated_at => updated_at)


Tag.create!(:id => 1,
            :name => "lokka")

Tagging.create!(:id => 1,
                :taggable_id => 1,
                :taggable_type => "Entry",
                :tag_context => "tags",
                :tag_id => 1)

# draft post
# id 2
Entry.create!(:user_id => 1,
              :category_id => 1,
              :title => "Draft Post",
              :body => "draft post",
              :type => "Post",
              :draft => true,
              :slug => 'test_draft_page',
              :created_at => created_at,
              :updated_at => updated_at)
Tagging.create!(:id => 2,
                :taggable_id => 2,
                :taggable_type => "Entry",
                :tag_context => "tags",
                :tag_id => 1)

# lokka can mix timezones
# lokka see only date and hours, ignore UTC offsets

# post after 1 minutes
# id 3
Entry.create!(:user_id => 3,
              :title => "Test Post2",
              :body => "Test Post2",
              :type => "Post",
              :created_at => created_at_tokyo + 1.minutes,
              :updated_at => created_at_tokyo + 1.minutes)

# page
# id 4
Entry.create!(:user_id => 1,
              :title => "Test Page",
              :body => "test Page",
              :type => "Page",
              :created_at => created_at,
              :updated_at => updated_at)

# draft page
# id 5
Entry.create!(:user_id => 1,
              :title => "Draft Page",
              :body => "draft Page",
              :type => "Page",
              :created_at => created_at,
              :updated_at => updated_at)

# kramdown
# id 6
Entry.create!(:user_id => 1,
              :title => "Markdown",
              :body => "# hi! \nmarkdown test",
              :markup => "kramdown",
              :type => "Post",
              :created_at => created_at,
              :updated_at => updated_at)

# redcloth
# id 7
Entry.create!(:user_id => 1,
              :title => "Textile",
              :body => "h1. hi!  \ntextile test",
              :markup => "redcloth",
              :type => "Post",
              :created_at => created_at,
              :updated_at => updated_at)

# wikicloth
# id 8
Entry.create!(:user_id => 1,
              :title => "MediaWiki",
              :body => "= hi! = \nmediawiki test",
              :markup => "wikicloth",
              :type => "Post",
              :created_at => created_at,
              :updated_at => updated_at)

# continue reading
# id 9
Entry.create!(:user_id => 1,
              :title => "Continue Reading",
              :body => "a\n\n<!--more-->\n\nb\n\n<!--more-->\n\nc\n",
              :markup => "kramdown",
              :type => "Post",
              :created_at => created_at,
              :updated_at => updated_at)

# for custom permalink
# id 10
Entry.create!(:user_id => 1,
              :title => "1 day later",
              :body => "1 day passed",
              :markup => "kramdown",
              :slug => "a-day-later",
              :type => "Post",
              :created_at => created_at + 1.days,
              :updated_at => created_at + 1.days)
