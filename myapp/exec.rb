require 'java'

class Task
  include Java::JavaUtilConcurrent::Callable

  def initialize(num)
    @num = num
  end

  def call
    test = {}
    test[:task] = "this is task #{@num}"
    test[:value] = @num
    return test
  end
end




Executors = Java::JavaUtilConcurrent::Executors
executor = Executors.newFixedThreadPool(8)

futures = (1..100).map do |i|
  executor.submit Task.new(i)
end

rets = futures.map { |f| f.get }
#puts "return values: #{rets.join("\n")}"

executor.shutdown
