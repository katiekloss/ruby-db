class DB::Directory

  def initialize(dir)
    @dir = dir
  end


  def file(name)
    path = "#{@dir}/#{name}"
    FileUtils.touch(path) unless File.exist?(path)

    File.open(path, 'r+')
  end


  def ls(glob)
    Dir["#{@dir}/#{glob}"]
  end

end
