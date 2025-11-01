module DB::Client

  MEMTABLE_MAX = 1024


  def initialize(dir)
    @dir = DB::Directory.new(dir)
    @wal = DB::WAL.new(@dir)
    @memtable = @wal.to_memtable
    @sstables = DB::SSTable.load_from_disk(@dir)
  end


  def set(id, value)
    if @memtable.count >= MEMTABLE_MAX
      flush_memtable!
    end

    @wal.set(id, value)
    @memtable[id] = value
  end


  def get(id)
    if result = @memtable[id]
      return to_nil(result)
    end

    # Nothing in the memtable--we have to search the disk.
    @sstables.each do |table|
      if result = table.get(id)
        return to_nil(result)
      end
    end

    nil
  end


  def delete(id)
    set(id, :tombstone)
  end


  private

    def to_nil(value)
      value == :tombstone ? nil : value
    end


    def flush_memtable!
      @sstables.unshift(DB::SSTable.new_from_memtable(@dir, @memtable))
      @memtable = {}
    end

end
