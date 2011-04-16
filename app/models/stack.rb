require 'mongoid'
require 'delayed_job_mongoid'

module TweetEngine
  class Stack
    
    include Mongoid::Document
    
    field :message
    field :sending_at, :type => Time, :default => Time.now
    field :delivered, :default => false
    field :repeat, :default => false
    field :every
    
    scope :to_deliver, where(:sending_at.lte => Time.now)
    
    after_create :deliver
    
    validates_length_of :message, :maximum => 140, :message => "must be less than 140 characters"
    validates :sending_at, :date => { :after_or_equal_to => Time.now }
    
    def sendable?
      Time.now >= self.sending_at
    end
    
    def deliver
      if self.sendable?
        Twitter.update self.message
        self.update_attribute :delivered, true
        self.delivered
        set_when_repeatable
      end
    end
    
    handle_asynchronously :deliver, :run_at => Proc.new {|p| p.sending_at }
    
    protected
    
    def set_when_repeatable
      if self.repeat
        TweetEngine::Stack.create!(
          :message => self.message,
          :sending_at => (Time.now + eval(self.every.split(' ').join('.'))),
          :repeat => true,
          :every => self.every
         )
      end
    end
  end
end