require 'fileutils'

module DoomwadBot
  class WadDownloader
    attr_reader :downloaded_file, :unpacked_dir, :slug_for_wad

    def initialize(base_dir: Dir.tmpdir, idgame_entry:)
      @base_dir = base_dir
      @idgame_entry = idgame_entry
      @downloaded_file = local_file_name
      @unpacked_dir = File.expand_path(slug_for_wad, @base_dir)
    end

    def download_and_unpack
      download
      unpack
    end

    def download
      raw = RestClient::Request.execute(
           method: :get,
           url: @idgame_entry.mirror_url,
           raw_response: true)
      FileUtils.mv raw.file.path, @downloaded_file
    end

    def unpack
      extract_zip(@downloaded_file, @unpacked_dir) if File.exist?(@downloaded_file)
      list_wads
    end

    def list_wads
      Dir.glob("**/*.{wad,WAD}", base: @unpacked_dir)
    end

    def slug_for_wad
      "#{@idgame_entry.id}-#{@idgame_entry.title.downcase.gsub(/[^a-z0-9]+/, '-').chomp('-')}"
    end

    private

    def local_file_name
      File.expand_path("#{slug_for_wad}.zip", @base_dir)
    end

    def extract_zip(file, destination)
      FileUtils.mkdir_p(destination)

      Zip::File.open(file) do |zip_file|
        zip_file.each do |f|
          fpath = File.join(destination, f.name)
          FileUtils.mkdir_p(File.dirname(fpath))
          zip_file.extract(f, fpath) unless File.exist?(fpath)
        end
      end
    end

  end
end
