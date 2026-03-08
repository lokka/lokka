# frozen_string_literal: true

require_relative '../test_helper'

class SnippetTest < LokkaTestCase
  def test_edit_link_with_id_1
    snippet = build(:snippet, id: 1)
    assert_equal '/admin/snippets/1/edit', snippet.edit_link
  end
end
