Site.create!(
  title:       "Test Site",
  description: "description...",
  dashboard:   %q(<p>Welcome to Lokka!</p><p>To post a new article, choose "<a href=""/admin/posts/new"">New</a>" under "Posts" on the menu to the left. To change the title of the site, choose "Settings" on the menu to the left. (The words displayed here can be changed anytime through the "<a href=""/admin/site/edit"">Settings</a>" screen.)</p>),
  theme:       "jarvi"
) && puts("site was successfully created") if Site.all.blank?

User.create!(
  name:                  "test",
  email:                 "test@test.com",
  password:              "test",
  password_confirmation: "test",
  permission_level:      1
) && puts("user was successfully created") if User.all.blank?

entry_params = {
  title:      "Test Post",
  body:       "<p>Welcome to Lokka!</p><p><a href=""/admin/"">Admin login</a> (user / password : test / test)</p>",
  type:       "Post"
}

Entry.create!(entry_params) { |e|
  e.user_id = User.first.id
}&& puts("entry was successfully created") if Entry.all.blank?

Snippet.create!(
  id:         1,
  name:       "Test Snippet",
  body:       "Text for test snippet."
) && puts("snippett was successfully created") if Snippet.all.blank?

Tag.create([
  { name: 'lokka'  },
  { name: 'fjord'  },
  { name: 'scottie'}
]) && puts("tag was successfully created") if Tag.all.blank?

tag_list = Tag.pluck(:name).join(',')
Entry.first.tagged_with(tag_list) && puts("tagging was successfully created") if Tagging.all.blank?
