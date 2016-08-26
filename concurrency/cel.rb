include Java
require 'pry'
require 'celluloid'
require 'celluloid/current'
require 'benchmark'

class MyLongTask
  include Celluloid

	def call(id)
    puts ">>>>>>>>>>>>>>>>>>    #{id}"
    if id.to_i > 5
      1000000.times do
        x = 22/7.0
      end
      puts " ---------- #{id} ----------------"
    end
		return "#{id} <<<<<<<<<<<<<<<<<<<"
	end
end

results = []
time = Benchmark.realtime do
#  pool = MyLongTask.pool
  pool = MyLongTask.pool(size: 3)
  label = []
  future = 10.times.map do |x|
    pool.future.call(x.to_s)
  end

  puts future.map(&:value)
end

puts time
