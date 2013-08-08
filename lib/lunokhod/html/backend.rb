require 'babosa'
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

    def write
      mkdir_p @output_dir
      cp_r @javascripts_path, @output_dir

      cd @output_dir do
        @products.each do |p|
          puts "Writing #{p.filename}"
          File.open(p.filename, 'w') { |f| f.write(p.content) }
        end
      end
    end

    def method_missing(m, *args)
      yield if block_given?
    end

    private

    class Product < Struct.new(:name, :content)
      def filename
        name.to_slug.normalize.to_s + '.html'
      end

      def <<(str)
        content << str
      end
    end
  end
end
