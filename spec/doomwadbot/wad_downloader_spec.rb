describe DoomwadBot::WadDownloader do

  let(:idgame_entry)  {
    OpenStruct.new(
      id: 999,
      title: 'Example WAD!'
    )
  }

  context '#initialize' do
    let(:downloader)    { DoomwadBot::WadDownloader.new(idgame_entry: idgame_entry)}

    it 'creates correct filenames' do
      expect(downloader.downloaded_file).to eq("/tmp/999-example-wad.zip")
      expect(downloader.unpacked_dir).to eq("/tmp/999-example-wad")
    end
  end

  context '.download' do
    let(:tmpdir)        { Dir.mktmpdir( rand.to_s[2..11] ) }
    let(:downloader)    { DoomwadBot::WadDownloader.new(base_dir: tmpdir, idgame_entry: idgame_entry)}

    before(:each) do
      allow(RestClient::Request).to receive(:execute).and_return(OpenStruct.new(file: Tempfile.new("test")))
    end

    it 'downloads to the expected dir' do
      downloader.download
      expect(File.exist?( File.expand_path("999-example-wad.zip", tmpdir) )).to be true
    end
  end

  context '.unpack' do
    let(:tmpdir)        { Dir.mktmpdir( rand.to_s[2..11] ) }
    let(:downloader)    { DoomwadBot::WadDownloader.new(base_dir: tmpdir, idgame_entry: idgame_entry)}
    let(:unpacked)      { downloader.unpack }

    before(:each) do
      FileUtils.copy_file(
        fixture_path("example.zip"),
        File.expand_path("999-example-wad.zip", tmpdir)
      )
    end

    it 'unpacks all files' do
      downloader.unpack
      expect(File.exist?( File.expand_path("999-example-wad/README.txt", tmpdir) )).to be true
      expect(File.exist?( File.expand_path("999-example-wad/example/other.wad", tmpdir) )).to be true
    end

    it 'finds the wads' do
      expect(unpacked).to match_array(["my.wad", "example/other.wad"])
    end
  end
end
