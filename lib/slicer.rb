# Creates time slices through objects with start_at, end_at and weight methods
# The weight methods allows objects to be weighted so that certain objects
# will have a more significant impact on the result than others.
# 
# See slicer_test.rb for examples of usage

class Slicer
  
  SLICE_LENGTH = 15 * 60 # 15 minutes
  
  def self.slice(*objects)
    @objects = objects
    @slice_start_at = objects.collect{|o| o.start_at}.sort.first
    @data = slice_data_from_each_object
    keys = keys_used_by_objects
    output = hash_with_default_values_as_sum_of_object_values_for_key
    
    keys.each{|k| output[k]}
    
    return output
  end
  
  def initialize(object, start_at = nil)
    @object = object
    @start_at = start_at || object.start_at
    check_object
  end
  
  def slice_data
    @slice_data ||= get_slice_data
  end
  
  private
  def self.slice_data_from_each_object
    @objects.collect{|o| new(o, @slice_start_at).slice_data}
  end
  
  def self.keys_used_by_objects
    @data.collect{|d| d.keys}.flatten.uniq.sort
  end
  
  def self.hash_with_default_values_as_sum_of_object_values_for_key
    Hash.new { |hash, key| hash[key] = values_in_data_for(key).inject(:+) }
  end
  
  def self.values_in_data_for(key)
    @data.collect{|d| d[key]}.compact
  end
  
  def get_slice_data
    @slice_data = Hash.new
    slice_times.each{|t| @slice_data[t] = @object.start_at <= t ? @object.weight : 0}
    return @slice_data
  end
  
  def slice_times
    @slice_times ||= get_slice_times
  end
  
  def get_slice_times
    @slice_times = Array.new
    time = slice_start
    
    while time <= slice_end.to_f
      @slice_times << Time.at(time)
      time += SLICE_LENGTH
    end
    
    return @slice_times
  end
  
  def slice_start
    slice_after(@start_at)
  end
  
  def slice_end
    slice_before(@object.end_at)
  end
  
  def slice_before(time)
    beyond_slice = time.to_f % SLICE_LENGTH
    time - Time.at(beyond_slice)
  end
  
  def slice_after(time)
    slice_before(time) + SLICE_LENGTH
  end
  
  def check_object
    check_required(:start_at)
    check_required(:end_at)
    check_required(:weight)
  end
  
  def check_required(method)
    unless @object.respond_to? method
      raise "Object passed to #{self.class.to_s} must have a #{method} method. Object: #{@object.inspect}"
    end
  end
end
