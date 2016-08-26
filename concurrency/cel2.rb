include Java
require 'celluloid'
require 'celluloid/current'

class FilePutter
  include Celluloid

  def initialize(filename)
    @filename = filename
  end

  def load_file_and_print
    @file_contents = File.read @filename
    return @filename
  rescue
    return "ERROR >> #{@filename}"
  end

end

files = ["/var/log/kernel.log", "/var/log/system.log", "/var/log/ppp.log", "/var/log/secure.log"]
results = []
files.each do |file|
  fp = FilePutter.new file
  results <<  fp.future(:load_file_and_print)
end

puts results.map(&:value)
