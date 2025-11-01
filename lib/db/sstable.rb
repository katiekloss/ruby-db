class DB::SSTable

  class << self

    attr_accessor(:next_id)

    def new_from_memtable(dir, memtable)
      @next_id ||= 0
      @next_id += 1

      data_file = dir.file("#{@next_id.to_s.rjust(10, '0')}.data")
      block = Block.new
      memtable.sort.each do |k, v|
        tombstone = v == :tombstone
        block.kv_entries << { k:, v:, tombstone: }
      end
      block.write(data_file)

      new(data_file)
    end


    def load_from_disk(dir)
      dir.ls('*.data').sort.reverse.map do |file|
        new(file)
      end
    end

  end


  def initialize(data_file)
    @data_file = data_file
  end


  def get(key)
    # TODO: caching this better, maybe.
    # Or maybe it just ends up all in memory and it's fine!
    @data_file.seek(0)

    block = Block.new
    while !@data_file.eof? do
      block.read(@data_file)
      needle = block.kv_entries.to_a.bsearch { |e| key <=> e[:k] }

      if needle
        if needle[:tombstone] == 1
          return :tombstone
        else
          return needle[:v]
        end
      end
    end

    nil
  end

end
