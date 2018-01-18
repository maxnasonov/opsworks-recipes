ENV['AWS_REGION'] = node['prototype']['aws_region']

%w{aws-sdk s3encrypt}.each do |g|
  chef_gem g do
    action :install
    compile_time true
  end
end

# Require necessary gems and libraries
require 'aws-sdk'
require 's3encrypt'

directory "/opt/mellon" do
  recursive true
end

ruby_block 'download-mellon-files' do 
  block do
    node['prototype']['mellon_files'].each do |mellon_file|
      if mellon_file == "FederationMetadata.xml"
        S3encrypt.getfile("/opt/mellon/#{mellon_file}", mellon_file, node['prototype']['s3_bucket'], node['prototype']['encryption_context'])
      else
        S3encrypt.getfile("/opt/mellon/adfs.#{mellon_file.split('.')[-1]}", mellon_file, node['prototype']['s3_bucket'], node['prototype']['encryption_context'])
      end
    end
  end
end


include_recipe "beaver"

# Follow all logs in /var/log except some useless logs, and chef ones which are handled separately (see below).
beaver_tail "system_logs" do
  path "/var/log/*log"
  type "syslog"
  format "json"
  tags [
    "syslog",
    "prototype",
    node['prototype']['name'],
  ],
  exclude "(dpkg|alternatives|lastlog|chef|beaver)"
  add_field [
    "instanceID", `ec2metadata --instance-id`,
    "rm_type", "prototype"
  ]
end
