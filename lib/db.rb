class DB

  MEMTABLE_MAX = 1024


  def initialize(dir)
    @dir = Directory.new(dir)
    @wal = WAL.new(@dir)
    @memtable = @wal.to_memtable
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
    SSTable.all_reversed.each do |table|
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
      # flush to SSTable
      @memtable = {}
    end

end
