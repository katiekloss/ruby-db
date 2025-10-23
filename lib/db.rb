class DB

  def initialize(file)
    @file = file
  end


  def set(id, value)
    hash = as_hash
    hash[id] = value
    serialize!(hash)
  end


  def get(id)
    as_hash[id]
  end


  private

    def as_hash
      @hash = {}
      @file.seek(0)
      @file.each_line do |line|
        matches = line.match(/([0-9]*): (.*)/)
        @hash[matches[1].to_i] = matches[2]
      end

      @hash
    end


    def serialize!(hash)
      @file.truncate(0)

      hash.each do |key, value|
        @file.write("#{key}: #{value}\n")
      end

      @file.flush
    end

end
