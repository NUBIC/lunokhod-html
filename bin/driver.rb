#!/usr/bin/env ruby

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'lunokhod'
require 'ncs_navigator/lunokhod'

file = ARGV[0]

if !file
  puts "Usage: #$0 SURVEY"
  exit 1
end

data = File.read(file)

p = Lunokhod::Parser.new(data, file)

p.parse

ep = Lunokhod::ErrorReport.new(p.surveys)
ep.run

if ep.errors?
  $stderr.puts ep
  exit -1
end

r = Lunokhod::Resolver.new(p.surveys)
r.run

b = NcsNavigator::Lunokhod::Backend.new
c = Lunokhod::Compiler.new(p.surveys, b)
c.compile
b.write