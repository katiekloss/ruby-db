class DB::Segment

  SEGMENT_MAX = 1024


  class << self

    attr_accessor(:last_id, :dir)


    def all
      segments = Dir[@dir + '/*.segment']
      segments.sort_by! do |segment|
        segment.match(/\/(.*)\.segment/)[1].to_i
      end

      segments.map do |segment| new(segment) end
    end


    def find_open
      segments = all
      if segments.empty?
        new
      else
        segments.first
      end
    end


    def next_id!
      @last_id ||= 0
      @last_id += 1
      @last_id
    end

  end


  def initialize(file = nil)
    file ||= name

    @closed = false
    FileUtils.touch(file) unless File.exist?(file)
    @file = File.open(file, 'r+')
    @records = count_records
  end


  def write(id, value)
    @records += 1
    @file.seek(0, IO::SEEK_END)
    @file.write("#{id}: #{value}\n")
    @file.flush
  end


  def full?
    @records == SEGMENT_MAX
  end


  def close
    @closed = true
  end


  def get(id)
    @file.seek(0)
    entry = @file.each_line.reverse_each.detect do |line|
      line.start_with?("#{id}: ")
    end
    @file.seek(0)

    if entry
      entry.match(/[0-9]*: (.*)/)[1]
    else
      nil
    end
  end


  private

    def count_records
      @file.each_line.count || 0
    end


    def name
      @name ||= self.class.dir + '/' + "#{self.class.next_id!}.segment"
    end

end
