module ECSD
  module Helpers
    module Common
      def write_to_file(cluster, data, path = ECSD.config.options[:export_path] || DEFAULT_EXPORT_PATH)
        File.open("#{path}/#{cluster.downcase}.yml", 'w') do |f|
          f.write(data.join)
        end
      end

      def task_id(task)
        task.task_arn
            .split('/')
            .last
      end

      def task_definition_data(task)
        task.task_definition_arn
            .split('/')
            .last
            .split(':')
      end

      def cluster_name(task)
        task.cluster_arn
            .split('/')
            .last
      end

      def task_container(task)
        task.containers.find { |c| c.task_arn == task.task_arn }
      end

      def dyn_port(task_container)
        task_container.network_bindings
                      .first
                      .host_port
      end
    end
  end
end
