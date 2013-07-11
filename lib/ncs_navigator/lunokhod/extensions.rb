require 'lunokhod'

module NcsNavigator::Lunokhod
  module QuestionExtensions
    def multivalued?
      options[:pick] == :any
    end

    def selector_type
      multivalued? ? 'checkbox' : 'radio'
    end

    def name
      dei = options[:data_export_identifier]

      multivalued? ? "#{dei}[]" : dei
    end
  end

  module AnswerExtensions
    def choice?
      type.nil?
    end

    def value
      tag.sub(/\Aneg_/, '-')
    end
  end

  Lunokhod::Ast::Answer.send(:include, AnswerExtensions)
  Lunokhod::Ast::Question.send(:include, QuestionExtensions)
end
