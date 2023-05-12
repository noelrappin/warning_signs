RSpec.configure do |config|
  original_stderr = $stderr
  original_stdout = $stdout
  config.before(:all) do
    $stderr = File.open(File::NULL, "w")
  end
  config.after(:all) do
    $stderr = original_stderr
  end

  config.before(:each, block_stdout: true) do
    $stdout = File.open(File::NULL, "w")
  end

  config.after(:each, block_stdout: true) do
    $stdout = original_stdout
  end
end
