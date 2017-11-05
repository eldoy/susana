class String

  # Strip HTML tags
  def strip_tags
    self.gsub(/<\/?[^>]*>/, '')
  end

end
