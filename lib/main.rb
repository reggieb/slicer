$:.unshift File.join(File.dirname(__FILE__))

require 'slicer'
require 'activity'

hours = 60 * 60

activity_one = Activity.new
activity_one.start_at = Time.now
activity_one.end_at = Time.now + 2 * hours

activity_two = Activity.new
activity_two.start_at = Time.now - 1 * hours
activity_two.end_at = Time.now + 0.5 * hours
activity_two.weight = 10

activity_three = Activity.new
activity_three.start_at = Time.now + 0.3 * hours
activity_three.end_at = Time.now + 1.5 * hours
activity_three.weight = 100

puts "Output the sum of activity weightings present through period"
Slicer.slice(activity_one, activity_two, activity_three).each do |time, weight|
  puts "#{time} ---- #{weight}"
end


