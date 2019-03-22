require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*test.rb']#['test/api_test.rb', 'test/api2_test.rb']
  t.verbose = true
end
