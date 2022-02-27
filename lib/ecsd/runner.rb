module ECSD
  def start
    config.clusters.each do |cluster|
      core(cluster).handle!
    end
  end
  module_function :start

  private

  def core(cluster)
    ECSD::Core.new(cluster)
  end
  module_function :core
end