class DB

  def initialize(file)
    @file = file
  end


  def set(id, value)
    @file.seek(0, IO::SEEK_END)
    @file.write("#{id}: #{value}\n")
  end


  def get(id)
    @file.seek(0)
    entry = @file.each_line.reverse_each.detect do |line|
      line.start_with?("#{id}: ")
    end

    if entry
      entry.match(/[0-9]*: (.*)/)[1]
    else
      nil
    end
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

end
