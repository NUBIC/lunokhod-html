Then(/^I see the question "(.*?)"$/) do |text|
  page.should have_selector('.lunokhod-question', :text => text)
end

Then(/^the survey has the answers$/) do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end
