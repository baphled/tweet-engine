module TweetStack
  class Stack
    include Mongoid::Document
  
    field :message
    field :send_at, :type => DateTime
    field :delivered, :default => false
    
    scope :to_deliver, where(:send_at.lte => DateTime.current)
    
    def sendable?
      self.send_at <= DateTime.current
    end
    
    def deliver
      if self.sendable?
        Twitter.update self.message
        self.update_attribute :delivered, true
        self.delivered
      end
    end
  end
end