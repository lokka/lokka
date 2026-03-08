# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../support/integration_helper'

class AppTest < LokkaTestCase
  include InSiteContext

  def test_index_shows_site_title
    get '/'
    assert_match 'Test Site', last_response.body
  end

  def test_entries_sorted_by_created_at_descending
    create(:xmas_post, title: 'First Post')
    create(:newyear_post)

    get '/'
    body = last_response.body

    first_post_index = body.index(/First Post/)
    test_post_index = body.index(/Test Post \d+/)

    assert_operator first_post_index, :>, test_post_index
  ensure
    Post.destroy_all
  end

  def test_index_displays_10_posts
    11.times { create(:post) }

    get '/'
    regexp = %r{<h2 class="title"><a href=".*\/[^"]*">Test Post.*<\/a><\/h2>}

    assert_equal 10, last_response.body.scan(regexp).size
  ensure
    Post.destroy_all
  end

  def test_index_displays_5_posts_when_per_page_is_5
    11.times { create(:post) }
    Site.first.update(per_page: 5)

    get '/'
    regexp = %r{<h2 class="title"><a href=".*\/[^"]*">Test Post.*<\/a><\/h2>}

    assert_equal 5, last_response.body.scan(regexp).size
  ensure
    Site.first.update(per_page: 10)
    Post.destroy_all
  end

  def test_entry_page_shows_site_title
    post_record = create(:post)

    get "/#{post_record.id}"
    assert_match 'Test Site', last_response.body
  ensure
    Post.destroy_all
  end

  def test_post_comment_to_entry
    post_record = create(:post)
    Comment.destroy_all

    params = {
      check: 'check',
      comment: {
        name: 'lokka tarou',
        homepage: 'http://www.example.com/',
        body: 'good entry!'
      }
    }

    post "/#{post_record.id}", params
    assert_equal 1, Comment.count
  ensure
    Post.destroy_all
  end

  def test_tag_index_shows_site_title
    create(:tag, name: 'lokka')

    get '/tags/lokka/'
    assert_match 'Test Site', last_response.body
  ensure
    Tag.destroy_all
  end

  def test_category_index_shows_site_title
    category = create(:category)

    get "/category/#{category.id}/"
    assert_match 'Test Site', last_response.body
  ensure
    Category.destroy_all
  end

  def test_child_category_index_shows_site_title
    category = create(:category)
    category_child = create(:category_child, parent: category)

    get "/category/#{category.id}/#{category_child.id}/"
    assert_match 'Test Site', last_response.body
  ensure
    Category.destroy_all
  end

  def test_draft_post_entry_page_returns_404
    create(:draft_post_with_tag_and_category)
    post_record = Post.find_by(draft: true)

    get '/test-draft-post'
    assert_equal 404, last_response.status

    get "/#{post_record.id}"
    assert_equal 404, last_response.status
  ensure
    Post.destroy_all
    Category.destroy_all
  end

  def test_draft_post_not_shown_on_index
    create(:draft_post_with_tag_and_category)

    get '/'
    refute_match(/Draft Post/, last_response.body)
  ensure
    Post.destroy_all
    Category.destroy_all
  end

  def test_draft_post_not_shown_on_tags_page
    create(:draft_post_with_tag_and_category)
    post_record = Post.find_by(draft: true)
    tag_name = post_record.tag_list.first

    get "/tags/#{tag_name}/"
    refute_match(/Draft Post/, last_response.body)
  ensure
    Post.destroy_all
    Category.destroy_all
  end

  def test_draft_post_not_shown_on_category_page
    create(:draft_post_with_tag_and_category)
    post_record = Post.find_by(draft: true)
    category_id = post_record.category.id

    get "/category/#{category_id}/"
    refute_match(/Draft Post/, last_response.body)
  ensure
    Post.destroy_all
    Category.destroy_all
  end

  def test_draft_post_not_shown_on_search_result
    create(:draft_post_with_tag_and_category)

    get '/search/?query=post'
    refute_match(/Draft Post/, last_response.body)
  ensure
    Post.destroy_all
    Category.destroy_all
  end

  def test_custom_permalink_access
    create(:page)
    create(:post_with_slug)
    create(:later_post_with_slug)
    Option.permalink_enabled = true
    Option.permalink_format = '/%year%/%monthnum%/%day%/%slug%'

    get '/2011/01/09/welcome-lokka'
    assert_match 'Welcome to Lokka!', last_response.body

    get '/2011/01/10/a-day-later'
    assert_match '1 day passed', last_response.body
  ensure
    Option.permalink_enabled = false
    Entry.destroy_all
  end

  def test_redirect_to_custom_permalink_from_original
    create(:post_with_slug)
    Option.permalink_enabled = true
    Option.permalink_format = '/%year%/%monthnum%/%day%/%slug%'

    get '/welcome-lokka'
    assert last_response.redirect?
    follow_redirect!
    assert_match '/2011/01/09/welcome-lokka', last_request.url
  ensure
    Option.permalink_enabled = false
    Entry.destroy_all
  end

  def test_no_redirect_when_permalink_disabled
    create(:post_with_slug)
    Option.permalink_enabled = false

    get '/welcome-lokka'
    refute last_response.redirect?
  ensure
    Entry.destroy_all
  end

  def test_page_does_not_redirect
    page = create(:page)
    Option.permalink_enabled = true
    Option.permalink_format = '/%year%/%monthnum%/%day%/%slug%'

    get "/#{page.id}"
    refute last_response.redirect?
  ensure
    Option.permalink_enabled = false
    Entry.destroy_all
  end

  def test_redirect_to_zero_filled_url
    create(:post_with_slug)
    Option.permalink_enabled = true
    Option.permalink_format = '/%year%/%monthnum%/%day%/%slug%'

    get '/2011/1/9/welcome-lokka'
    assert last_response.redirect?
    follow_redirect!
    assert_match '/2011/01/09/welcome-lokka', last_request.url
  ensure
    Option.permalink_enabled = false
    Entry.destroy_all
  end

  def test_remove_trailing_slash
    create(:post_with_slug)
    Option.permalink_enabled = true
    Option.permalink_format = '/%year%/%monthnum%/%day%/%slug%'

    get '/2011/01/09/welcome-lokka/'
    assert last_response.redirect?
    follow_redirect!
    assert_match '/2011/01/09/welcome-lokka', last_request.url
  ensure
    Option.permalink_enabled = false
    Entry.destroy_all
  end

  def test_custom_permalink_returns_200
    create(:post_with_slug)
    Option.permalink_enabled = true
    Option.permalink_format = '/%year%/%monthnum%/%day%/%slug%'

    get '/2011/01/09/welcome-lokka'
    assert_equal 200, last_response.status
  ensure
    Option.permalink_enabled = false
    Entry.destroy_all
  end

  def test_custom_permalink_not_found_returns_404
    Option.permalink_enabled = true
    Option.permalink_format = '/%year%/%monthnum%/%day%/%slug%'

    get '/2011/01/09/welcome-wordpress'
    assert_equal 404, last_response.status
  ensure
    Option.permalink_enabled = false
  end

  def test_wrong_path_structure_returns_404
    Option.permalink_enabled = true
    Option.permalink_format = '/%year%/%monthnum%/%day%/%slug%'

    get '/obviously/not/existing/path'
    assert_equal 404, last_response.status
  ensure
    Option.permalink_enabled = false
  end

  def test_custom_permalink_post_comment
    create(:post_with_slug)
    Option.permalink_enabled = true
    Option.permalink_format = '/%year%/%monthnum%/%day%/%slug%'
    Comment.destroy_all

    params = {
      check: 'check',
      comment: {
        name: 'lokka tarou',
        homepage: 'http://www.example.com/',
        body: 'good entry!'
      }
    }

    post '/2011/01/09/welcome-lokka', params
    assert_equal 1, Comment.count
  ensure
    Option.permalink_enabled = false
    Entry.destroy_all
  end

  def test_continue_reading_hidden_on_index
    create(:post_with_more)

    regexp = %r{<p>a<\/p>\n\n<a href="\/[^"]*">Continue reading\.\.\.<\/a>\n*[ \t]+<\/div>}
    get '/'
    assert_match regexp, last_response.body
  ensure
    Post.destroy_all
  end

  def test_continue_reading_not_hidden_on_entry_page
    create(:post_with_more)

    regexp = %r{<a href="\/9">Continue reading\.\.\.<\/a>\n*[ \t]+<\/div>}
    get '/post-with-more'
    refute_match regexp, last_response.body
  ensure
    Post.destroy_all
  end

  def test_tag_archive_page
    create(:tag, name: 'lokka')
    post_record = create(:post)
    post_record.tag_collection = 'lokka'
    post_record.save

    get '/tags/lokka/'
    assert last_response.ok?
    assert_match(/Test Post \d+/, last_response.body)
  ensure
    Post.destroy_all
    Tag.destroy_all
  end
end
