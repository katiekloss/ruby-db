class DB::SSTable::Block < BinData::Record
  uint16le :entry_count, value: -> { kv_entries.length }

  array :kv_entries, initial_length: :entry_count do
    uint64le :k

    uint16le :v_len, value: -> { v.length }
    string :v, read_length: :v_len

    bit1 :tombstone
  end

end
