class Theme
  @types = []
  def index?;    @types.include?(:index); end
  def search?;   @types.include?(:search); end
  def category?; @types.include?(:category); end
  def yearly?;   @types.include?(:yearly); end
  def monthly?;  @types.include?(:monthly); end
  def daily?;    @types.include?(:daily); end
  def document?; @types.include?(:document); end
end
