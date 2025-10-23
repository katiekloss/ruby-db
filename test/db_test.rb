require_relative './test_helper'

class DBTest < ActiveSupport::TestCase

  def setup
    temp_file = Tempfile.new('test.db')
    @db = DB.new(temp_file)

    at_exit do
      temp_file.close
      temp_file.unlink
    end
  end


  def test_set_get
    @db.set(1, 'hello world')
    value = @db.get(1)

    assert_equal('hello world', value)
  end

end

