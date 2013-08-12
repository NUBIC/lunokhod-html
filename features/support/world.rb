require 'fileutils'
require 'tmpdir'

class TestWorld
  include FileUtils

  attr_accessor :dir
end

World { TestWorld.new }

Before do
  self.dir = Dir.mktmpdir

  puts "Scratch directory: #{dir}"
end

After do
  rm_rf dir
end
