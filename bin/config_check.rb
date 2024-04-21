$:.unshift File.join( File.dirname(__FILE__), "..", "lib")
require "doomwadbot"

install_dir = File.join( File.dirname(__FILE__), "..")

config = {
  wad2image_path: File.expand_path( File.join( install_dir, "ext", "wad2image") ),
  iwads_path: File.expand_path( File.join( install_dir, "ext", "iwads") ),
  wads_base_dir: File.expand_path( File.join( install_dir, "data", "wads") ),
  images_base_dir: File.expand_path( File.join( install_dir, "data", "images") ),
  config_dir: File.expand_path( File.join( install_dir, "etc", "config") ),
  memory: File.expand_path( File.join( install_dir, "etc", "memory.json") ),
  mastodon: {
    base_url: ENV["MASTODON_BASE_URL"],
    bearer_token: ENV["MASTODON_BEARER_TOKEN"]
  }
}

bot = DoomwadBot::Bot.new(config: config)

bot.wads.each do |wad|
  begin
    print wad.link
    metadata = wad.idgames.metadata
    puts "[#{metadata.title}]...OK"
    #dl = WadDownloader.new(base_dir: config[:wads_base_dir], idgame_entry: metadata)
  rescue => e
    puts " #{e} ...FAILED"
  end
end
