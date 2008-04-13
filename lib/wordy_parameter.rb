module WordyParameter
  def to_param
    if self.respond_to?("page")
      title = page.title
    else
      title = self.title
    end
    title.gsub(/ /, '_')
  end
end
