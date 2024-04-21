require 'date'

module DoomwadBot
  class Memory

    attr_reader :memory_data

    def initialize(file:)
      @file = file
    end

    def load!
      @memory_data = if File.exist?(@file)
                        JSON.parse( File.read(@file), symbolize_names: true )
                     else
                        Hash.new
                      end
    end

    def add_entry(section:, idgames:, data:)
      section = @memory_data[section] ||= {}
      section["#{idgames.id}-#{idgames.metadata[:title]}"] = data
    end

    def entry?(section:, idgames:)
      return false unless @memory_data[section]
      section = @memory_data[section]
      section.key?("#{idgames.id}-#{idgames.metadata[:title]}")
    end

    def save!
      @memory_data[:saved] = DateTime.now.iso8601
      File.open(@file, "w") do |f|
        f.write(@memory_data.to_json)
      end
      @memory_data
    end

  end
end
