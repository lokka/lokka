require 'bluefeather'

class Entry
  def body_html
    BlueFeather.parse(attribute_get(:body))
  end
end
