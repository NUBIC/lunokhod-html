require 'babosa'
require 'erb'
require 'escape_utils'
require 'escape_utils/html/erb'
require 'fileutils'

module Lunokhod::Html
  class Backend
    include FileUtils::Verbose

    attr_accessor :level

    def initialize(output_dir)
      @output_dir = output_dir
      @javascripts_path = File.expand_path('../../../../javascripts', __FILE__)
      @products = []

      @survey_start, @survey_end = template('survey.html.erb')
    end

    def mapping
      @products.each_with_object({}) { |p, h| h[p.name] = p.filename }
    end

    def prologue
    end

    def epilogue
    end

    def write
      mkdir_p @output_dir
      cp_r @javascripts_path, @output_dir

      @products.each do |p|
        p.output_dir = @output_dir
        puts "Writing #{p.filename}"
        File.open(p.filename, 'w') { |f| f.write(p.content) }
      end
    end

    def survey(n)
      @current_product = Product.new(n.name, "")
      e @survey_start.result(binding)
      yield
      e @survey_end.result(binding)
      @products << @current_product
    end

    def method_missing(m, *args)
      e "<!-- #{m} #{args.first.uuid} -->\n"
      yield if block_given?
    end

    private

    def e(str)
      @current_product << str
    end

    def template(path)
      data = File.read(File.expand_path("../templates/#{path}", __FILE__))

      data.split('%%SPLIT%%', 2).map { |str| ERB.new(str) }
    end

    class Product < Struct.new(:name, :content, :output_dir)
      def filename
        File.join(output_dir, name.to_slug.normalize.to_s + '.html')
      end

      def <<(str)
        content << str
      end
    end
  end
end
