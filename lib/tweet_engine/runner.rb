require 'djinn/rails'
require 'mongoid'

module TweetEngine
  
  class Runner
    
    include Djinn::Rails

    djinn do

      start do
        log "Using keywords #{TweetEngine.config['keywords']}"
        log "You current have #{TweetEngine::SearchResult.all.count} potential followers"

        @tweeple_search = TweetEngine::SearchJob.new
        loop do
          log "Searching for more tweeple"
          @tweeple_search.searching
          log "Now have #{TweetEngine::SearchResult.all.count} potential followers"
          sleep TweetEngine.config['interval']
        end
      end

      stop do
        log "Djinn is stopping.."
      end

      exit do
        log "Stopping search.."
      end
    end
    
  end
end