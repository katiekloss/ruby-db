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


  def test_double_set
    @db.set(1, 'hello world')
    @db.set(1, 'goodbye world')

    value = @db.get(1)
    assert_equal('goodbye world', value)
  end


  def test_set_multiple
    @db.set(1, '1')
    @db.set(2, '2')

    value = @db.get(1)
    assert_equal('1', value)

    value = @db.get(2)
    assert_equal('2', value)
  end

end

