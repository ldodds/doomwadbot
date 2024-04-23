module DoomwadBot
  class WadImages
    attr_reader :images

    def initialize(logger:, config:, wad:)
      @logger = logger
      @config = config
      @wad = wad
    end

    def extract_images
      @images = []
      #lookup wad metadata
      metadata = @wad.idgame.metadata

      @logger.info('Downloading WAD')
      #download and unpack wad
      downloader = WadDownloader.new(base_dir: @config[:wads_base_dir], idgame_entry: metadata)
      list_of_wads = downloader.download_and_unpack

      if list_of_wads.empty?
        @logger.error('No WADS found') if list_of_wads.empty?
      else
        @logger.debug("Choosing #{list_of_wads.first} from #{list_of_wads}")
        analyser = WadAnalyser.new(
          config: @config,
          wad_file: File.expand_path(list_of_wads.first, downloader.unpacked_dir),
          slug: downloader.slug_for_wad,
          logger: @logger)
        @images = analyser.create_map_images
      end
      true
    end

    def select_images(num = 4)
      @images.sample(num)
    end
  end
end
