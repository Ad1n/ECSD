# @example
#   ECSD.config do |c|
#     c.clusters = %w[cluster0 cluster1 cluster2]
#     c.region = "aws_region_name"
#     c.credentials = { AWS_ACCESS_KEY_ID: "ID", AWS_SECRET_ACCESS_KEY: "SECRET" }
#     c.options = {
#       export_path: 'dir/path/to/export_config/folder',
#       timeout: 101
#     }
#     c.logger = Logger.new($stdout)
#   end
module ECSD
  unless defined?(CoreConfig)
    class CoreConfig < Struct.new(:credentials, :region, :clusters, :options, :logger)
      # @param payload [Hash] { AWS_ACCESS_KEY_ID: 'XXX', AWS_SECRET_ACCESS_KEY: 'XXX' }
      def credentials=(payload)
        validate_credentials!(payload)
        super(::Aws::Credentials.new(
          payload[:AWS_ACCESS_KEY_ID],
          payload[:AWS_SECRET_ACCESS_KEY]
        ))
      end

      # @param payload [Hash] { export_path: 'path/to/folder', timeout: 0 }
      def options=(payload)
        payload[:export_path] ||= ECSD::DEFAULT_EXPORT_PATH
        payload[:export_format] ||= ECSD::Constants::DEFAULT_EXPORT_FORMAT
        unless [Constants::FORMATS[:json], Constants::FORMATS[:yml]].include?(payload[:export_format])
          raise UnknownExportFormatError, "Invalid export format: #{payload[:export_format]}"
        end
        payload[:timeout] ||= 0
        super(payload)
      end

      private

      # Removing the secret credentials from the default inspect string.
      # @api private
      def inspect
        "#<#{self.class.name} clusters=#{clusters.inspect} region=#{region.inspect} options=#{options.inspect} logger=#{logger.inspect}>"
      end

      def validate_credentials!(p)
        raise Config::ValidationError, 'Please, provide AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY' if p.values.size != 2
        raise Config::ValidationError, 'Invalid AWS credentials' unless p.values.all? String
      end
    end
  end

  def config
    yield @config if block_given?

    @config
  end
  module_function :config

  def logger
    @config.logger || Logger.new($stdout)
  end
  module_function :logger

  @config ||= CoreConfig.new
end
