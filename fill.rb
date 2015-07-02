#!/usr/bin/env ruby
# encoding: utf-8

require 'redic'

src_dir = ARGV.shift
exit unless src_dir

AUTOCOMPLE_KEY = "autocomplete"
c = Redic.new

files = Dir[File.join(src_dir, "src", "*.c")] + Dir[File.join(src_dir, "src", "*.h")]
added = 0
files.each do |f|
  File.open(f).each do |line|
    m = line.match(/(\S+)\(.+\) {/)
    next unless m
    fn = m[1].tr("!(*","")
    next if fn.empty?
    added += c.call("ZADD", AUTOCOMPLE_KEY, 0, fn)
  end
end
puts "Added #{added} items"
