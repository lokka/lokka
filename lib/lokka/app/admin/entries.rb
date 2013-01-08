module Lokka
  class App
    # posts
    get   ('/admin/posts')          { get_admin_entries(Post) }
    get   ('/admin/posts/new')      { get_admin_entry_new(Post) }
    post  ('/admin/posts')          { post_admin_entry(Post) }
    get   ('/admin/posts/:id/edit') { |id| get_admin_entry_edit(Post, id) }
    put   ('/admin/posts/:id')      { |id| put_admin_entry(Post, id) }
    delete('/admin/posts/:id')      { |id| delete_admin_entry(Post, id) }

    # pages
    get   ('/admin/pages')          { get_admin_entries(Page) }
    get   ('/admin/pages/new')      { get_admin_entry_new(Page) }
    post  ('/admin/pages')          { post_admin_entry(Page) }
    get   ('/admin/pages/:id/edit') { |id| get_admin_entry_edit(Page, id) }
    put   ('/admin/pages/:id')      { |id| put_admin_entry(Page, id) }
    delete('/admin/pages/:id')      { |id| delete_admin_entry(Page, id) }
  end
end
