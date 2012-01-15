require 'puppet/cloudpack'
require 'puppet/face/node_aws'

Puppet::Face.define :node_aws, '0.0.1' do
  action :list_volumes do

    summary 'List EBS volumes'

    description <<-'EOT'
      This action lists EBS volumes
    EOT

    when_invoked do |options|
      Puppet::CloudPack.list_volumes(options)
    end 

    when_rendering :console do |value|
      value.collect do |id, props|
        "#{id}:\n" + props.collect do |field, val|
          "  #{field}: #{val}"
        end.sort.join("\n")
      end.sort.join("\n")
    end 

    returns "List of volumes with their properties"

    examples <<-'EOT'
       $ puppet node_aws list_volume
    EOT

  end 
end
