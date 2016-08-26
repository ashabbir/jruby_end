include Java
require 'pry'
require 'benchmark'

class MyLongTask
	include java.util.concurrent.Callable

	def initialize(id, label)
    @id = id
		@label = label
	end

	def call
    @label << @id
		return @label
	end
end


time = Benchmark.realtime do
  future = Array.new
  label = []
  executor = java.util.concurrent.Executors::newFixedThreadPool(30)
  1000.times do |x|
    future[x] = executor.submit(MyLongTask.new(x.to_s, label))
  end

  until future.map(&:done?).all?{ |x| x == true}
  end
  binding.pry
end

puts time
exit
