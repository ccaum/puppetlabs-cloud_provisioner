require 'puppet/cloudpack'
require 'puppet/face/node_aws'

Puppet::Face.define :node_aws, '0.0.1' do
  action :attach_volume do

    summary 'Attach a volume to an instance'

    description <<-'EOT'
      This action attaches an EBS volume to an EC2 instance
    EOT

    Puppet::CloudPack.add_attach_volume_options(self)

    when_invoked do |options|
      Puppet::CloudPack.create_volume(options)
    end 

    when_rendering :console do |value|
      value.to_s
    end 

    examples <<-'EOT'
       $ puppet node_aws create_volume --size 10 [ --snapshot-id snap-7334e011 ]
       vol-ccc507a1
    EOT

  end 
end
