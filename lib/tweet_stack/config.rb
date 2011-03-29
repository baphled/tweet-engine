module TweetStack
  def self.config
    @@config ||= {}
  end

  def self.config=(hash)
    @@config = hash
  end
end