require 'erb'
require 'escape_utils'
require 'lunokhod'
require 'lunokhod/version'

require File.expand_path('../extensions', __FILE__)

module NcsNavigator::Lunokhod
  class Backend
    attr_accessor :level

    def initialize
      @prologue = template('prologue.html.erb')
      @epilogue = template('epilogue.html.erb')
      @survey = template('survey.html.erb')
      @section = template('section.html.erb')
      @group = template('group.html.erb')
      @label = template('label.html.erb')
      @question = template('question.html.erb')
      @answer = template('answer.html.erb')
      @grid = template('grid.html.erb')

      @in_grid = false
      @grid_as = []
      @grid_qs = []
    end

    def prologue
      @start = Time.now
      @buffer = ""

      e @prologue.result(binding)
    end

    def epilogue
      total = Time.now - @start

      e @epilogue.result(binding)
    end

    def survey(n)
      start, finish = split_output @survey.result(binding)
      e start
      yield
      e finish
    end

    def section(n)
      start, finish = split_output @section.result(binding)
      e start
      yield
      e finish
    end

    def group(n)
      start, finish = split_output @group.result(binding)
      e start
      yield
      e finish
    end

    def label(n)
      start, finish = split_output @label.result(binding)
      e start
      yield
      e finish
    end
    
    def question(n)
      if @in_grid
        # Queue up the question for later processing by the grid generator
        @grid_qs << n
        yield
      else
        start, finish = split_output @question.result(binding)
        e start
        yield
        e finish
      end
    end

    def answer(n)
      if @in_grid
        # Queue up the answer for later processing by the grid generator
        @grid_as << n
        yield
      else
        q = n.question
        start, finish = split_output @answer.result(binding)
        e start
        yield
        e finish
      end
    end

    def grid(n)
      begin
        @in_grid = true
        @grid_as.clear
        @grid_qs.clear

        yield

        e @grid.result(binding)
      ensure
        @in_grid = false
      end
    end
    
    def write
      puts @buffer
    end

    def method_missing(m, *args)
      e "<!-- #{m} #{args.first.uuid} -->"
      yield if block_given?
    end

    private

    def e(str)
      @buffer << ("  " * (level || 0)) << str << "\n"
    end

    def h(val)
      EscapeUtils.escape_html(val.to_s)
    end

    def template(fn)
      ERB.new(File.read(File.expand_path("../templates/#{fn}", __FILE__)))
    end

    # HACK: Lunokhod doesn't currently yield intermediate products back to
    # other backend methods, and likely won't do so for quite a while.  This is
    # a hack to get around that limitation.
    def split_output(out)
      out.split('%DATA%', 2)
    end
  end
end
