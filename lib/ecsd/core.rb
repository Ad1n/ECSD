module ECSD
  class Core
    include Helpers::EC2
    include Helpers::ECS
    include Helpers::Common

    attr_reader :ecs, :ec2, :cluster

    def initialize(cluster_name)
      @ecs = ::Aws::ECS::Client.new(
        credentials: ECSD.config.credentials,
        region: ECSD.config.region
      )
      @ec2 = ::Aws::EC2::Client.new(
        credentials: ECSD.config.credentials,
        region: ECSD.config.region
      )
      @cluster = cluster_name
    end

    def handle!
      task_arns = task_arns(cluster)
      tasks = connected_tasks(cluster, task_arns)
      handle_tasks(tasks)
    end

    def handle_tasks(tasks)
      ECSD.logger.info <<~TEXT

        Handle cluster: [#{cluster}]
        Started at: #{Time.now}
      TEXT
      tasks.map do |t|
        instance_id = instance_id(cluster, t)
        task_definition_name, task_revision = task_definition_data(t)
        task_container = task_container(t)

        TEMPLATE.call(
          ip_addr: instance_ip_addr(instance_id),
          dyn_port: dyn_port(task_container),
          task_id: task_id(t),
          task_definition_name: task_definition_name,
          task_revision: task_revision,
          cluster_name: cluster_name(t),
          container_name: task_container.name,
          instance_id: instance_id
        )
      end.then do |r|
        write_to_file(cluster, r)

        ECSD.logger.info <<~TEXT

          Handled cluster: [#{cluster}]
          Tasks in cluster: #{r.count}
          Finished at: #{Time.now}
        TEXT

        {
          cluster: cluster,
          tasks_count: r.count
        }
      end
    end
  end
end
