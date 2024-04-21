module DoomwadBot
  class Cacowards < Collection

    def category
      :cacowards
    end

    def wads
      load_wad_list if @wads.nil?
      @wads
    end

    private

    def load_wad_list
      @wads = []
      CSV.foreach(wad_list, headers: true) do |row|
        @wads << Wad.new(
          category: row[0],
          year: row[1].to_i,
          award: row[2],
          title: row[3],
          mappers: row[4],
          link: row[5]
        ) unless row[5].nil?
      end
      true
    end

    def wad_list
      File.join(@config[:config_dir], "doom-wads.csv")
    end

  end
end
