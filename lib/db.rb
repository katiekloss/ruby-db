class DB

  def initialize(dir)
    Segment.dir = dir
    @segment = Segment.find_open
  end


  def set(id, value)
    if @segment.full?
      @segment.close
      @segment = Segment.new
    end

    @segment.write(id, value)
  end


  def get(id)
    Segment.all.each do |segment|
      if result = segment.get(id)
        return result
      end
    end

    nil
  end


  private

    def find_open_segment
      segments = Dir[dir + '/*.segment']
      segments.sort_by! do |segment|
        segment.match(/\/(.*)\.segment/)[1].to_i
      end

      segments.first
    end

end
