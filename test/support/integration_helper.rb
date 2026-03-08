# frozen_string_literal: true

module InSiteContext
  def setup
    super
    create(:site)
  end
end
