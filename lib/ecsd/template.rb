# frozen_string_literal: true

module ECSD
  TEMPLATE = lambda do |ip_addr:,
                        dyn_port:,
                        task_id:,
                        task_definition_name:,
                        task_revision:,
                        cluster_name:,
                        container_name:,
                        instance_id:,
                        metrics_path: DEFAULT_METRICS_PATH|
    {
      "targets" => ["#{ip_addr}:#{dyn_port}"],
      "labels" => {
        "task_id" => task_id,
        "task_definition_name" => task_definition_name,
        "task_revision" => task_revision.to_i,
        "cluster_name" => cluster_name,
        "container_name" => container_name,
        "instance_id" => instance_id,
        "__metrics_path__" => metrics_path
      }
    }
  end
end
