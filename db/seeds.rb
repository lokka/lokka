created_at = updated_at = "2011-01-09T05:39:08+09:00"

Site.create!(:title => "Test Site",
             :description => "description...",
             :dashboard => %q(<p>Welcome to Lokka!</p><p>To post a new article, choose "<a href=""/admin/posts/new"">New</a>" under "Posts" on the menu to the left. To change the title of the site, choose "Settings" on the menu to the left. (The words displayed here can be changed anytime through the "<a href=""/admin/site/edit"">Settings</a>" screen.)</p>),
             :theme => "jarvi",
             :created_at => created_at,
             :updated_at => updated_at) && puts("site was successfully created") if Site.all.blank?

User.create!(:name => "test",
             :hashed_password => "6338db2314bba79531444996b780fa7036480733",
             :salt => "2Z4H4DzATC",
             :permission_level => 1,
             :created_at => created_at,
             :updated_at => updated_at) && puts("user was successfully created") if User.all.blank?

Entry.create!(:user_id => 1,
              :title => "Test Post",
              :body => "<p>Welcome to Lokka!</p><p><a href=""/admin/"">Admin login</a> (user / password : test / test)</p>",
              :type => "Post",
              :created_at => created_at,
              :updated_at => updated_at) && puts("entry was successfully created") if Entry.all.blank?

Snippet.create!(:id => 1,
                :name => "Test Snippet",
                :body => "Text for test snippet.",
                :created_at => created_at,
                :updated_at => updated_at) && puts("snippett was successfully created") if Snippet.all.blank?

Tag.create!(:id => 1,
            :name => "lokka") && puts("tag was successfully created") if Tag.all.blank?

Tagging.create!(:id => 1,
                :taggable_id => 1,
                :taggable_type => "Entry",
                :tag_context => "tags",
                :tag_id => 1) && puts("tagging was successfully created") if Tagging.all.blank?
