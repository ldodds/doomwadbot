module DoomwadBot
  class Collection
    def self.choose(config:, memory:)
      Cacowards.new(config: config, memory: memory)
    end

    def initialize(config:, memory:)
      @config = config
      @memory = memory
    end

    def category
      raise 'implement in subclass'
    end

    def wads
      raise 'implement in subclass'
    end

    def choose_wad
      wads.sample
    end
  end
end
