Feature: HTML representation
  Background:
    Given the survey
    """
    survey "Mini survey" do
      section "One" do
        q_1 "A question"
        a_1 "Yes"
        a_2 "No"
      end
    end
    """

  @wip
  Scenario: When a survey is loaded, its responses are empty
    When I load "Mini survey"

    Then I see the question "A question"
    And the survey has the answers
      | question   | answer |
      | A question | nil    |

# vim:ts=2:sw=2:et:tw=78
