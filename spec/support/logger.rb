class TestLogger
  attr_accessor :history

  def initialize
    @history = []
  end

  def warn(message)
    @history << message
  end
end

RSpec.configure do |config|
  config.before(:example) do
    without_partial_double_verification do
      logger = TestLogger.new
      allow(Rails).to receive(:logger).and_return(logger)
    end
  end
end
