RSpec.configure do |config|
  original_stderr = $stderr
  config.before(:all) do
    $stderr = File.open(File::NULL, "w")
  end
  config.after(:all) do
    $stderr = original_stderr
  end
end
