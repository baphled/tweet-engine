module TweetStack
  class Stack
    include Mongoid::Document
  
    field :message
    field :send_at, :type => DateTime
    field :delivered, :default => false
    
    def scheduled?
      self.send_at <= DateTime.current
    end
    
    def deliver
      if self.scheduled?
        Twitter.update self.message
        self.update_attribute :delivered, true
        self.delivered
      end
    end
  end
end