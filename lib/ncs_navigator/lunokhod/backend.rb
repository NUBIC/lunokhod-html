require 'erb'
require 'escape_utils'
require 'lunokhod'
require 'lunokhod/version'

module NcsNavigator::Lunokhod
  class Backend
    attr_accessor :level

    def initialize
      @buffer = ""
      @prologue = template('prologue.html.erb')
      @epilogue = template('epilogue.html.erb')
      @survey = template('survey.html.erb')
      @section = template('section.js.erb')
      @question = template('question.js.erb')
    end

    def prologue
      @start = Time.now

      e @prologue.result(binding)
    end

    def epilogue
      duration = Time.now - @start

      e @epilogue.result(binding)
    end

    def survey(n)
      start, finish = @survey.result(binding).split('%%DATA%%')
      e start
      yield
      e finish
    end

    def section(n)
      start, finish = @section.result(binding).split('%%DATA%%')
      e start
      yield
      e finish
    end

    def question(n)
      start, finish = @question.result(binding).split('%%DATA%%')
      e start
      yield
      e finish
    end
    
    def write
      puts @buffer
    end

    def method_missing(m, *args)
      if args.first.respond_to?(:uuid)
        e "// #{m} #{args.first.uuid}"
        yield if block_given?
      else
        super
      end
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
  end
end
