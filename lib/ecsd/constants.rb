module ECSD
  module Constants
    DEFAULT_METRICS_PATH = '/metrics'.freeze
    DEFAULT_EXPORT_PATH = (File.expand_path('../..', __dir__) << '/export').freeze
    LAUNCH_TYPE = 'EC2'.freeze
    CONNECTIVITY = {
      connected: 'CONNECTED'
    }.freeze
  end
end
