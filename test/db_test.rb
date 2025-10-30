require_relative './test_helper'

class DBTest < ActiveSupport::TestCase

  def setup
    FileUtils.rm_rf(Dir['tmp/*'])

    @db = DB.new('tmp')
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


  def test_multiple_segments
    (1024 * 5).times do |i|
      @db.set(i, 'hello world')
    end

    (1024 * 5).times do |i|
      assert_equal('hello world', @db.get(i))
    end
  end


  def test_delete
    @db.set(1, '1')
    @db.delete(1)

    value = @db.get(1)
    assert_equal(nil, value)
  end


  def test_restore
    @db.set(1, '1')
    new_db = DB.new('tmp')

    value = new_db.get(1)
    assert_equal('1', value)
  end

end

