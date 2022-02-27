module ECSD
  module Helpers
    module EC2
      # @param instance_id [String]
      # @return [String] private ip
      def instance_ip_addr(instance_id)
        ec2.describe_instances(instance_ids: Array(instance_id))
           .data
           .reservations
           .first
           .instances
           .first
           .private_ip_address
      end
    end
  end
end
