require 'lunokhod'
require 'lunokhod/html'

module Lunokhod::Html
  ##
  # Use this to drive the compilation process.
  class Driver
    attr_reader :data
    attr_reader :filename
    attr_reader :output_dir

    def initialize(output_dir, data, filename)
      @data = data
      @filename = filename
      @output_dir = output_dir
    end

    ##
    # Returns a [status, mapping, report] message, where:
    #
    # - status is true if compilation succeeded and false otherwise,
    # - mapping is a survey title => filename map, and
    # - report is a Lunokhod::ErrorReport containing zero or more referential
    #   integrity errors.
    def run
      p = Lunokhod::Parser.new(data, filename)
      p.parse

      ep = Lunokhod::ErrorReport.new(p.surveys)
      ep.run

      if ep.errors?
        return [false, ep]
      end

      r = Lunokhod::Resolver.new(p.surveys)
      r.run

      b = Lunokhod::Html::Backend.new(output_dir)
      c = Lunokhod::Compiler.new(p.surveys, b)
      c.compile
      b.write

      [true, b.mapping, ep]
    end
  end
end
