module DoomwadBot
  class Poster
    def initialize(logger:, config:, wad:, wad_images:)
      @logger = logger
      @config = config
      @wad = wad
      @wad_images = wad_images
      @images = @wad_images.select_images.sort
    end

    def post_text
      text = "#{@wad.idgame.metadata[:title]}\n"
      if @wad.mappers
        text = text + "by #{@wad.mappers}\n\n"
      end
      if @wad.category
        text = text + "#{@wad.category}, #{@wad.year}"
        if @wad.award
          text = text + " (#{@wad.award})"
        end
        text = text + "\n\n"
      end
      text = text + "#{@wad.link}\n"

      numbers = map_numbers.compact
      text = text + "#{numbers.size > 1 ? 'Maps' : 'Map'}: #{numbers.compact.join(', ')}\n\n"
      text = text + "#Doom\n"
      text
    end

    def map_numbers
      @images.map do |image_path|
        map_name(image_path)
      end
    end

    def post
      #create attachments
      uploaded = []
      @images.each do |img|
        alt_text = "#{@wad.idgame.metadata[:title]} #{map_name(img)}"
        @logger.debug("Uploading media #{img} with alt-text: #{alt_text}")
        uploaded << create_client.upload_media(File.new(img), {description: alt_text})
      end

      @logger.info('Uploaded all media, creating post')
      status = create_client.create_status(post_text, { visibilty: :public, media_ids: uploaded.map{|m| m.id } })
      @logger.debug(status)
      @logger.info('Successfully posted')
      true
    end

    private

    def map_name(image_path)
      file = image_path.split("/").last
      file.split(".").first.upcase
    end

    def create_client
      @client ||= ::Mastodon::REST::Client.new(base_url: @config[:mastodon][:base_url], bearer_token: @config[:mastodon][:bearer_token], timeout: {read: 20})
    end

  end
end
