Given /^the datetime is frozen at "([^"]*)"$/ do |date_time_string|
  time = Time.parse(date_time_string)
  Timecop.freeze(time)
end

Given /^the datetime is reset to "([^"]*)" but time continues to pass$/ do |date_time_string|
  time = Time.parse(date_time_string)
  Timecop.travel(time)
end

Given /^the datetime is unfrozen and reset to now$/ do
  Timecop.return
end
