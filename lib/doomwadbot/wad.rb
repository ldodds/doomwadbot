module DoomwadBot
  class Wad
    attr_reader :category, :year, :award, :title, :mappers, :link, :idgame

    def initialize(category: nil, year: nil, award: nil, title: nil, mappers: nil, link: nil)
      @category = category
      @year = year
      @award = award
      @title = title
      @mappers = mappers
      @link = link
      @idgame = idgames_metadata(@title, @link)
    end

    private

    def idgames_metadata(title, link)
      return nil if link.nil?
      idgame = IdGames.from_doomworld_url(link)
      if idgame.nil?
        IdGames.for_non_doomworld(title, link)
      else
        idgame
      end
    end
  end
end
