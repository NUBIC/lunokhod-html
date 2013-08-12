Given(/^the survey$/) do |string|
  ok, @mapping, report = Lunokhod::Html::Driver.new(dir, string, '(string)').run

  if !ok
    puts report.errors
    fail 'Compilation failed'
  end
end

When(/^I load "(.*?)"$/) do |title|
  fn = @mapping[title]

  if !fn
    fail %Q{Unable to map "#{title}" to a survey file}
  end

  visit "file:///#{fn}"
end

# vim:ts=2:sw=2:et:tw=78
