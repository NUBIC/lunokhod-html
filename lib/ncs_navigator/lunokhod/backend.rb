require 'lunokhod'
require 'lunokhod/version'

module NcsNavigator::Lunokhod
  module QuestionExtensions
    def pick
      options[:pick]
    end
  end

  module AnswerExtensions
    def choice?
      type.nil?
    end
  end

  Lunokhod::Ast::Answer.send(:include, AnswerExtensions)
  Lunokhod::Ast::Question.send(:include, QuestionExtensions)

  class Backend
    attr_accessor :level

    def prologue
      @start = Time.now
      @buffer = ""

      e "<!DOCTYPE html>"
      e "<html>"
      e "<head>"
      e %Q{<meta name="generator" value="Lunokhod #{::Lunokhod::VERSION}">}
      e %Q{<meta charset="utf-8">}
      e %Q{<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.1/jquery.min.js"></script>}
      e "</head>"
      e "<body>"
    end

    def epilogue
      total = Time.now - @start

      e "<!-- generated in #{total} seconds -->"
      e "</body>"
      e "</html>"
    end

    def survey(n)
      e '<article>'
      e "<header><h1>#{h n.name}</h1></header>"
      e '<form>'
      yield
      e '</form>'
      e '</article>'
    end

    def section(n)
      e '<section>'
      e "<header><h2>#{h n.name}</h2></header>"
      e '<ol>'
      yield
      e '</ol>'
      e '</section>'
    end

    def label(n)
      e %q{<li class="lunokhod-label">}
      e %Q{<span class="lunokhod-label-text">#{h n.text}</span>}
      yield if block_given?
      e %q{</li>}
    end
    
    def question(n)
      e %q{<li class="lunokhod-question">}
      e %Q{<span class="lunokhod-question-text">#{h n.text}</span>}
      e %Q{<ol id="#{n.uuid}" data-pick="#{n.pick}">}
      yield
      e %q{</ol>}
      e %q{</li>}
    end

    def answer(n)
      q = n.parent
      dei = q.options[:data_export_identifier]
      val = n.tag

      if val.start_with?('neg_')
        val.sub!('neg_', '-')
      end

      e %q{<li class="lunokhod-answer">}

      input_type, name = case q.pick
                         when :any
                           ['checkbox', "#{dei}[]"]
                         else
                           ['radio', dei]
                         end

      selector_classes = ["lunokhod-answer-select"].join(' ')

      e %Q{<label>}

      if n.choice?
        e %Q{<input class="#{selector_classes}" type="#{input_type}" name="#{name}" value="#{val}"></input>}
        e %Q{<span class="lunokhod-answer-text">#{h n.text}</span>}
      else
        # Multiple input elements will result in a submission like this:
        #
        #   foo=1&foo=2
        #
        # The interpretation of this is up to the application server.  To
        # eliminate this ambiguity, we assign the input field the name.  For
        # pick-ones, we additionally generate a bit of Javascript that brings
        # back the radio-button behavior.
        input_classes = ["lunokhod-entry"].join(' ')
        e %Q{<input id="#{n.uuid}" class="#{selector_classes}" type="#{input_type}" data-name="#{name}"></input>}

        if q.pick == :one
          e %Q{<script type="text/javascript">
                $(function () {
                  $("##{n.uuid}").change(function () {
                    var name = $(this).data('name');

                    if ($(this).prop('checked')) {
                      $('input[name="#{name}"]').prop('checked', false);
                    }
                  });

                  $('input[name="#{name}"]').change(function () {
                    if ($(this).prop('checked')) {
                      $('##{n.uuid}').prop('checked', false);
                    }
                  });
                });
              </script>
          }
        end

        case n.type
        when :string
          e %Q{<input class="#{input_classes}" type="text" name="#{name}"></input>}
        when :time
          e %Q{<input class="#{input_classes}" type="time" name="#{name}"></input>}
        when :datetime
          e %Q{<input class="#{input_classes}" type="datetime" name="#{name}"></input>}
        else
      end

      end

      e %q{</label>}

      yield

      e %q{</li>}
    end

    def dependency(n)
      e %q{<script type="text/javascript">}
      yield
      e %q{</script>}
    end

    def condition(n)
      case n.parsed_condition
      when Lunokhod::ConditionParsing::AnswerSelected
        e %q{// AnswerSelected}
      when Lunokhod::ConditionParsing::AnswerCount
        e %q{// AnswerCount}
      when Lunokhod::ConditionParsing::AnswerSatisfies
        e %q{// AnswerSatisfies}
      when Lunokhod::ConditionParsing::SelfAnswerSatisfies
        e %q{// SelfAnswerSatisfies}
      end

      yield
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

    # TODO: escape
    def h(str)
      str
    end
  end
end
