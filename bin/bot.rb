$:.unshift File.join( File.dirname(__FILE__), "..", "lib")
require "doomwadbot"
require 'dotenv'

install_dir = File.join( File.dirname(__FILE__), "..")

Dotenv.load('.env', '.env.development.local')

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


#puts config.inspect
bot = DoomwadBot::Bot.new(config: config, test_mode: false)

bot.run
