#
# Author:: 
# Copyright:: 
#

require 'chef/knife/cloud/server/list_command'
require 'chef/knife/oraclepaas_helpers'
require 'chef/knife/cloud/oraclepaas_compute_service'
require 'chef/knife/cloud/oraclepaas_service_options'

class Chef
  class Knife
    class Cloud
      class OraclepaasSecruleList < ResourceListCommand
        include OraclepaasHelpers

        banner "knife oraclepaas secrule list (options)"

        def create_service_instance     
          ComputeService.new
        end

        def before_exec_command
          @columns_with_info = [
            { label: 'Name',        	key: 'name', value_callback: method(:pretty_name)},
            { label: 'Disabled',      key: 'disabled'},
            { label: 'Action',       key: 'action' }
          ]

          @sort_by_field = 'name'
        end

        def query_resource
          @service.list_security_rules
        end
			
				def validate_params!
          super
          errors = check_for_missing_config_values!(:oraclepaas_username, :oraclepaas_password, :oraclepaas_domain, :oraclepaas_compute_api)
          if errors.any?
            error_message = "The following required parameters are missing: #{errors.join(', ')}"
            ui.error(error_message)
            raise CloudExceptions::ValidationError, error_message
          end
        end

        def pretty_name(name)
	      	pretty_name = name.sub "/Compute-#{locate_config_value(:oraclepaas_domain)}/#{locate_config_value(:oraclepaas_username)}/", ''
	      	pretty_name
        end

        def list(resources)
          puts "Note: For clarity the container name (/Compute-#{locate_config_value(:oraclepaas_domain)}/#{locate_config_value(:oraclepaas_username)}/) has been removed from each of the security rule names listed below. "
          super
        end
      end
    end
  end
end
