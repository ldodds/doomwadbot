require 'csv'
require 'logger'

module DoomwadBot

  class Bot
    attr_reader :wads

    def initialize(config:, test_mode: false)
      @logger = Logger.new($stdout)
      @config = config
      @test_mode = test_mode
      load_memory
    end

    def run
      @logger.info('Running bot')

      collection = Collection.choose(config: @config, memory: @memory)
      wad = collection.choose_wad

      @logger.info("Chosen WAD: #{wad.idgame.metadata[:title]} from Collection #{collection.category}")

      @logger.info('Extracting images...')
      wad_images = WadImages.new(logger: @logger, config: @config, wad: wad)
      wad_images.extract_images

      #wad2image can throw an error
      #it can end up not producing an images
      #
      # shotgun-symphony, extracts to a nested dir and so can't find wad
      @logger.info("Extracted #{wad_images.images.length} images")

      #pick images
      to_post = wad_images.select_images

      if to_post.empty?
        @logger.error('Unable to post as no images found')
        return
      end

      poster = Poster.new(logger: @logger, config: @config, wad: wad, images: to_post)
      puts poster.post_text

      #SSL and time out errors from botsinspace
      if !@test_mode

        success = poster.post

        #update memory

        #save memory
        @memory.save!
      end
      true
    end

    private

    def load_memory
      @memory = Memory.new(file: @config[:memory])
      @memory.load!
    end
  end
end
