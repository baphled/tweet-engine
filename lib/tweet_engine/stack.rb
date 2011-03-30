require 'mongoid'
require 'delayed_job_mongoid'

module TweetEngine
  class Stack
    
    include Mongoid::Document
    
    field :message
    field :sending_at, :type => Time, :default => Time.now
    field :delivered, :default => false
    
    scope :to_deliver, where(:sending_at.lte => Time.now)
    
    def sendable?
      Time.now >= self.sending_at
    end
    
    def deliver
      if self.sendable?
        Twitter.update self.message
        self.update_attribute :delivered, true
        self.delivered
      end
    end
    
    handle_asynchronously :deliver, :run_at => Proc.new {|p| p.sending_at }
    
  end
end