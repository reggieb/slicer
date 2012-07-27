
$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'slicer'
require 'activity'


class SlicerTest < Test::Unit::TestCase
  
  def setup
    @activity = Activity.new
    @activity.start_at = Time.local(2012, 1, 1, 9, 10, 0) # 9:10
    @activity.end_at = Time.local(2012, 1, 1, 15, 3, 0) # 15:03
    @slicer = Slicer.new(@activity)
  end
  
  def test_slice
    assert_equal(@slicer.slice_data, Slicer.slice(@activity))
  end
  
  def test_slice_with_two_identical_activities
    slices = Slicer.slice(@activity, @activity)
    assert_equal([@activity.weight * 2], slices.values.uniq)
  end
  
  def test_slice_with_different_activities
    one = Activity.new
    one.start_at = Time.local(2012, 1, 1, 9, 10, 0) # 9:10
    one.end_at = Time.local(2012, 1, 1, 9, 35, 0) # 9:35
    
    two = Activity.new
    two.start_at = Time.local(2012, 1, 1, 8, 55, 0) # 8:55
    two.end_at = Time.local(2012, 1, 1, 9, 20, 0) # 9:20
    two.weight = 2
    
    expected_values = [2, 3, 1]
    slices = Slicer.slice(one, two)
    
    assert_equal(expected_values, slices.values)
  end
  
  def test_slice_data_length
    expected_slice_count = 24
    assert_equal(expected_slice_count, @slicer.slice_data.length)
  end
  
  def test_slice_data_values
    assert_equal([@activity.weight], @slicer.slice_data.values.uniq)
  end
    
  def test_slice_data_start
    expected_start = Time.local(2012, 1, 1, 9, 15, 0) # 9:15
    assert_equal(expected_start, @slicer.slice_data.keys.first)
  end
  
  def test_slice_data_end
    expected_end = Time.local(2012, 1, 1, 15, 0, 0) # 15:00
    assert_equal(expected_end, @slicer.slice_data.keys.last)
  end
  
  def test_slice_data_with_start_date
    start_at = Time.local(2012, 1, 1, 8, 55, 0) # 8:55
    expected_start = Time.local(2012, 1, 1, 9, 0, 0) # 9:00
    slicer = Slicer.new(@activity, start_at)
    assert_equal(25, slicer.slice_data.length)
    assert_equal(0, slicer.slice_data.values.first)
    assert_equal(1, slicer.slice_data.values.last)
    assert_equal(expected_start, slicer.slice_data.keys.first)
  end
  
  def test_with_invalid_object
    assert_raise RuntimeError do
      Slicer.new("", Time.now)
    end
  end
  
end
