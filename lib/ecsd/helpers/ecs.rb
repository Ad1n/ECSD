module ECSD
  module Helpers
    module ECS
      # @param cluster [String] cluster name
      # @return [Array<Array<String>>] batched task_arns by 100
      def task_arns(cluster)
        ecs.list_tasks(cluster: cluster).each.with_object([]) do |response, task_arns|
          task_arns << response[:task_arns]
        end
      end

      # @param cluster [String] cluster name
      # @param task_arns [Array<Array<String>>] batched task_arns by 100
      # @return [Array<Array<Aws::ECS::Types:Task>>] connected tasks
      def connected_tasks(cluster, task_arns)
        task_arns.each.with_object([]) do |pt_batch, connected_tasks|
          connected_tasks << ecs.describe_tasks(cluster: cluster, tasks: pt_batch)
                                .data
                                .tasks
                                .select { |t| t.connectivity == ECSD::Constants::CONNECTIVITY[:connected] }
        end.flatten
      end

      # @param cluster [String] cluster name
      # @param task [Aws::ECS::Types::Task]
      # @return [String]
      def instance_id(cluster, task)
        ecs.describe_container_instances(
          cluster: cluster,
          container_instances: Array(task.container_instance_arn)
        ).data
           .container_instances
           .first
           .ec2_instance_id
      end
    end
  end
end
