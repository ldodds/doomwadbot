require 'ostruct'

module DoomwadBot
  class IdGames
    attr_reader :id, :file

    def initialize(id: nil, file: nil)
      raise if id.nil? && file.nil?
      @id = id
      @file = file
    end

    #https://www.doomworld.com/idgames/?id=16965
    #https://www.doomworld.com/idgames/levels/doom2/Ports/megawads/cchest4
    #https://www.doomworld.com/idgames/?file=levels/doom2/Ports/d-f/fueldevr
    #
    #...or some other domain, or nil
    def self.from_doomworld_url(url)
      return nil if url.nil? || url.empty?
      return nil unless url.match("doomworld.com")
      if url.match("(.*)\?id=([0-9]+)")
        return IdGames.new(id: url.match("(.*)\?id=([0-9]+)")[2])
      elsif url.match("(.*)\?file=(.+)")
        return IdGames.new(file: url.match("(.*)\?file=(.+)")[2])
      else
        #already normalised to https in config
        return IdGames.new(file: url.gsub("https://www.doomworld.com/idgames/", ""))
      end
    end

    def self.for_non_doomworld(title, link)
      return OpenStruct.new(
        id: 999,
        file: nil,
        metadata: OpenStruct.new(title: title, mirror_url: link)
      )
    end

    def metadata
      metadata = get_metadata_with_retry( api_url )
      metadata[:mirror_url] = create_mirror_url( metadata[:dir], metadata[:filename] )
      OpenStruct.new( metadata )
    end

    def mirror_url
      wad = metadata
      create_mirror_url( wad.dir, wad.filename )
    end

    private

    #Bit of a hack but some doomworld urls don't work in API unless you add a
    #.zip extension and no obvious way to see which ones require it, so do a limited
    #retry if we get an error
    def get_metadata_with_retry(url, try_again: true)
      response = RestClient.get url
      parsed_body = JSON.parse( response.body, symbolize_names: true )
      #if there's content then request was successful. API doesn't use status codes :(
      return parsed_body[:content] if parsed_body[:content]
      #puts "Retrying #{url}" if try_again && !url.end_with?("zip")
      return get_metadata_with_retry("#{url}.zip", try_again: false) if try_again && !url.end_with?("zip")
      raise url
    end

    #should rotate base urls if doing a lot of downloading
    def create_mirror_url(dir, filename)
      #the dir attribute has a trailing slash
      "https://www.quaddicted.com/files/idgames/#{dir}#{filename}"
    end

    def api_url()
      if @id
        "https://www.doomworld.com/idgames/api/api.php?action=get&out=json&id=#{@id}"
      else
        "https://www.doomworld.com/idgames/api/api.php?action=get&out=json&file=#{@file}"
      end
    end
  end
end
