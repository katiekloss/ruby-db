class DB::WAL

  def initialize(dir)
    @file = dir.file('wal')
  end


  def set(id, value)
    @file.write("#{id}:#{value}\n")
    @file.flush
  end


  def to_memtable
    hash = {}

    @file.seek(0)
    @file.each_line do |line|
      matches = line.match(/([0-9]*):(.*)/)
      hash[matches[1].to_i] = matches[2]
    end

    hash
  end

end
