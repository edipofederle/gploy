require 'test/unit'

#Run all tests.
tests = Dir["#{File.dirname(__FILE__)}/test_*.rb"]
tests.each do |file|
  require file
end