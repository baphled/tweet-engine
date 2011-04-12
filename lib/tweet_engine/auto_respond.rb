require 'djinn/rails'
require 'mongoid'

module TweetEngine
  
  class AutoRespond
    
    include Djinn::Rails

    djinn do

      start do
        log "Responding to auto-response"

        @responder = TweetEngine::Responder.new
        loop do
          log "Searching for more tweeple"
          sent_to = TweetEngine::Responder.respond
          log "Now have #{sent_to.count} people"
          sleep TweetEngine.config['interval']
        end
      end

      stop do
        log "Auto-Respond is stopping.."
      end

      exit do
        log "Stopping Auto-Respond.."
      end
    end
    
  end
end