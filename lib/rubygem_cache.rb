module RubygemCache
  def self.find_by_name name
    Rails.cache.fetch ["rubygem", name] { Rubygem.find_by! name: name }
  end

  def self.flush_by_gem gem
    Rails.cache.delete ["rubygem", gem.name]
  end
end