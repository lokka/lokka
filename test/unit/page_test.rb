# frozen_string_literal: true

require_relative '../test_helper'

class PageTest < LokkaTestCase
  def test_first_does_not_raise_error
    Page.first
  end
end
