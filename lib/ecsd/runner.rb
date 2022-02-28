module ECSD
  # @info Start ECS clusters discovery
  def start(cycle: :infinite)
    case cycle
    when :infinite
      loop { invoke!; wait }
    else
      invoke!
    end
  end
  module_function :start

  private

  # @info one discovery cycle invocation
  def invoke!
    config.clusters.each do |cluster|
      core(cluster).handle!
    end
  end
  module_function :invoke!

  # @info Initialize core component
  # @param cluster [String] cluster name
  def core(cluster)
    ECSD::Core.new(cluster)
  end
  module_function :core

  # @info Time in seconds between discovery iterations
  def wait
    sleep ECSD.config.options[:timeout]
  end
  module_function :wait
end
