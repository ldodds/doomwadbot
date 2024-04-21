describe DoomwadBot::IdGames do
  context '#from_doomworld_url' do
    let(:url)     { "https://example.org" }
    let(:idgames) { DoomwadBot::IdGames.from_doomworld_url(url)}

    context 'with id parameter link' do
      let(:url)   { "https://www.doomworld.com/idgames/?id=16965" }
      it 'parses correctly' do
        expect(idgames.id).to eq "16965"
        expect(idgames.file).to be_nil
      end
    end

    context 'with file parameter link' do
      let(:url)   { "https://www.doomworld.com/idgames/?file=levels/doom2/Ports/d-f/fueldevr" }
      it 'parses correctly' do
        expect(idgames.id).to be_nil
        expect(idgames.file).to eq "levels/doom2/Ports/d-f/fueldevr"
      end
    end

    context 'with direct link' do
      let(:url)   { "https://www.doomworld.com/idgames/levels/doom2/Ports/megawads/cchest4" }
      it 'parses correctly' do
        expect(idgames.id).to be_nil
        expect(idgames.file).to eq "levels/doom2/Ports/megawads/cchest4"
      end
    end

    it 'ignores everything else' do
      expect(idgames).to be_nil
    end
  end

  context '.metadata' do
    let(:id)          { 1234 }
    let(:idgames)     { DoomwadBot::IdGames.new(id: id) }
    let(:metadata)    { load_fixture('jbat.json') }
    let(:response)    { double(code: 200, body: metadata) }

    before(:each) do
      expect(RestClient).to receive(:get).and_return( response )
    end

    it 'fetches and parses metadata' do
      expect(idgames.metadata.id).to eq 20786
    end

    it 'adds mirror_url' do
      expect(idgames.metadata.mirror_url).to eq "https://www.quaddicted.com/files/idgames/levels/doom2/Ports/j-l/jbat.zip"
    end
  end

  context '.mirror_url' do
    let(:id)          { 1234 }
    let(:idgames)     { DoomwadBot::IdGames.new(id: id) }
    let(:metadata)    { load_fixture('jbat.json') }
    let(:response)    { double(code: 200, body: metadata) }

    before(:each) do
      expect(RestClient).to receive(:get).and_return( response )
    end

    it 'builds expected url' do
      expect(idgames.mirror_url).to eq "https://www.quaddicted.com/files/idgames/levels/doom2/Ports/j-l/jbat.zip"
    end
  end
end
