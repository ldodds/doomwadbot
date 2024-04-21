module DoomwadBot
  #we might do more than just extract images in future
  class WadAnalyser
    #wad2image_config is a hash of:
    # :wad2image => path to where wad2image can be found, e.g. File.expand_path('./ext/wad2image')
    # :iwads => path to where original wads can be found, e.g. File.expand_path('./ext/iwads')
    def initialize(config:, wad_file:, slug:)
      @config = config
      @wad_file = wad_file
      @slug = slug
    end

    def create_map_images
      system(wad2image_cmd, exception: true)
      Dir.glob("*.png", base: image_dir).map {|png| File.join(File.expand_path(image_dir), png) }
    end

    private

    def wad2image_cmd
      %{#{@config[:wad2image_path]}/bin/wad2image.py -j #{choose_style} -c yadex --wad-spath #{wad_spath} -o #{image_dir} #{@wad_file}}
    end

    def choose_style
      ['circle', 'sprite'].sample
    end

    def image_dir
      "#{@config[:images_base_dir]}/#{@slug}"
    end

    def wad_spath
      @config[:iwads_path]
    end
  end
end
