require 'tempfile'

describe DoomwadBot::Memory do

  let(:memory_file) { Tempfile.new("memory") }
  let(:memory)      { DoomwadBot::Memory.new(file: memory_file) }

  context 'when file doesnt exist' do
    let(:memory)      { DoomwadBot::Memory.new(file: "unknown.json") }

    it 'has empty memory' do
      expect(memory.load!).to eq({})
    end
  end

  context 'when there is saved data' do
    before(:each) do
      memory_file.write(JSON.dump({data: 123}))
      memory_file.rewind
    end

    it 'loads it' do
      expect(memory.load!).to eq( { data: 123 } )
    end
  end

  context 'when saving' do
    before(:each) do
      memory_file.write(JSON.dump({data: 123}))
      memory_file.rewind
      memory.load!
    end

    it 'saves the file' do
      m = memory.save!
      expect(m[:saved]).to_not be_nil
    end
  end

  context 'adding an entry' do
    let(:section)   { :award_winners }
    let(:idgames)   {
      OpenStruct.new(
        id: 999,
        metadata: OpenStruct.new(title: "abc")
      )
    }
    let(:data) { {shared: DateTime.now} }

    before(:each) do
      memory_file.write(JSON.dump({data: 123}))
      memory_file.rewind

      memory.load!
    end

    it 'adds correctly' do
      memory.add_entry(section: section, idgames: idgames, data: data)
      expect(memory.entry?(section: section, idgames: idgames)).to be true
      expect(memory.memory_data[:award_winners]["999-abc"]).to eq data
    end
  end
end
