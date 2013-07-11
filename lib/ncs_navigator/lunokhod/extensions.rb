require 'lunokhod'

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
end
