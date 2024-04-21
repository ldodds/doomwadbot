require 'rake'
require 'rake/clean'
require 'fileutils'

BASE_DIR="data"
WADS_DIR="#{BASE_DIR}/wads"
IMAGES_DIR="#{BASE_DIR}/images"

CLEAN.include ["#{WADS_DIR}/**/*", "#{IMAGES_DIR}/**/*.png"]

#You own the WADS, right?
task :install do
  FileUtils.mkdir_p("data/wads")
  FileUtils.mkdir_p("data/images")
  FileUtils.mkdir_p("etc/iwads")

  sh %{cd ext; git clone https://github.com/selliott512/wad2image.git} unless File.exist?('./ext/wad2image')
  sh %{curl -L "https://archive.org/download/DOOMIWADFILE/DOOM.WAD" -o ext/iwads/doom.wad} unless File.exist?('./ext/iwads/doom.wad')
  sh %{curl -L "https://archive.org/download/DOOM2IWADFILE/DOOM2.WAD" -o ext/iwads/doom2.was} unless File.exist?('./ext/iwads/doom2.wad')
end

#just for testing everything is setup OK
task :wad2image, [:wad_path] do |t,args|
  image_dir = "#{IMAGES_DIR}/#{File.basename(args[:wad_path], '.*')}"
  iwad = File.absolute_path('./ext/iwads')
  sh %{./ext/wad2image/bin/wad2image.py -c yadex --wad-spath #{iwad} -o #{image_dir} #{args[:wad_path]}}
end
