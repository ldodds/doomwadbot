require 'pry'
require 'fakefs/spec_helpers'

require 'doomwadbot'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.order = 'random'
end

def fixture_path(filename)
  File.join( File.dirname(__FILE__), "fixtures", filename )
end

def load_fixture(filename)
  File.read( fixture_path(filename) )
end
