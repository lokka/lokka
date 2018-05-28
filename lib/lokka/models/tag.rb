# frozen_string_literal: true

class Tag
  def link
    "/tags/#{name}/"
  end
end

##
# Retrieving Tag.
#
# @param [String] Tag name
# @return [Tag] Tag instance
def Tag(name)
  Tag.first(name: name)
end
