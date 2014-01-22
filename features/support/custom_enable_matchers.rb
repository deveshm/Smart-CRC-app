RSpec::Matchers.define :be_enabled do
  match do |actual|
    driver_result = actual[:disabled]
    # nil, false, or "false" will all satisfy this matcher
    (driver_result.nil? || driver_result == false || driver_result == "false").should be_true
  end
end

RSpec::Matchers.define :be_disabled do
  match do |actual|
    driver_result = actual[:disabled]
    (driver_result == "disabled" || driver_result == true || driver_result == "true").should be_true
  end
end