require 'pry'
require 'java'
#require 'xml-apis-1.3.02.jar'

path = File.expand_path('./data/*.txt' , __dir__)
files = Dir[path]

array = []

files.each do |file|
  File.readlines(file).each do |l|
    array << l
  end
end

puts array
array.uniq!
puts "*****"
puts array

binding.pry

