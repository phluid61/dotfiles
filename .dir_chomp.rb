#!/usr/bin/ruby --
print (ARGV[0]||ENV['PWD']||Dir.pwd).sub(/^#{ENV['HOME']}/,'~').scan(%r{^~|/[^/]+$|\/(?:\.?[^/])?}).join
